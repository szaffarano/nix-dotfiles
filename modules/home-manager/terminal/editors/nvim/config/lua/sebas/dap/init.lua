-- Thanks TJ DeVries for the following code:
local M = {}

local ok, Job, dap
ok, Job = pcall(require, 'plenary.job')
if not ok then
  print 'plenary.job not found'
  return
end

ok, dap = pcall(require, 'dap')
if not ok then
  print 'dap not found'
  return
end

local get_cargo_args = function(args)
  local result = {}

  assert(args.cargoArgs, vim.inspect(args))
  for idx, a in ipairs(args.cargoArgs) do
    table.insert(result, a)
    if idx == 1 and a == 'test' then
      -- Don't run tests, just build
      table.insert(result, '--no-run')
    end
  end

  table.insert(result, '--message-format=json')

  -- TODO: handle cargoExtraArgs

  return result
end

local function map(f, t)
  local result = {}
  for _, i in ipairs(t) do
    table.insert(result, f(i))
  end
  return result
end

M.select_rust_runnable = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local lsp_method = 'experimental/runnables'
  local lsp_call_params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }
  local lsp_handler = function(result)
    local items = vim.fn.flatten(map(function(i)
      return i.result
    end, result))

    vim.ui.select(items, {
      prompt = 'Rust Runnables',
      format_item = function(item)
        return item.label
      end,
    }, function(item)
      if item then
        M.debug_rust_runnable(item)
      end
    end)
  end

  vim.lsp.buf_request_all(bufnr, lsp_method, lsp_call_params, lsp_handler)
end

M.debug_rust_runnable = function(item)
  item = item or {}
  item = vim.deepcopy(item)

  vim.notify('Debugging: ' .. item.label)

  Job:new({
    command = 'cargo',
    args = get_cargo_args(item.args),
    cwd = item.args.workspaceRoot,
    on_exit = function(j, code)
      if code and code > 0 then
        vim.notify 'An error occured while compiling. Please fix all compilation issues and try again.'
      end

      vim.schedule(function()
        for _, value in pairs(j:result()) do
          local json = vim.fn.json_decode(value)
          if type(json) == 'table' and json.executable ~= vim.NIL and json.executable ~= nil then
            dap.run {
              name = 'Rust tools debug',
              type = 'lldb',
              request = 'launch',
              program = json.executable,
              args = item.args.executableArgs,
              cwd = item.workspaceRoot,
              stopOnEntry = false,
              runInTerminal = false,
            }
            break
          end
        end
      end)
    end,
  }):start()
end

return M
