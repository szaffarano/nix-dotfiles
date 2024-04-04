-- Thanks TJ DeVries for the following code:
-- vim.opt_local.formatoptions:remove 'o'

local ok, dap = pcall(require, 'dap')
if not ok then
  print 'dap not found'
  return
end

local function run_debugger()
  if dap.session() then
    dap.continue()
  else
    require('sebas.dap').select_rust_runnable()
  end
end

vim.keymap.set('n', '<F9>', run_debugger, { buffer = vim.api.nvim_get_current_buf(), desc = 'Debug: Start/Continue' })
