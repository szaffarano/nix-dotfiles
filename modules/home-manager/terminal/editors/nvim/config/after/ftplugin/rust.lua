vim.opt_local.formatoptions:remove 'o'

local ok, dap = pcall(require, 'dap')
if not ok then
  print 'dap not found'
  return
end

local function run_debugger()
  if dap.session() then
    dap.continue()
  else
    vim.cmd.RustLsp 'debuggables'
  end
end

vim.keymap.set('n', '<F9>', run_debugger, { buffer = vim.api.nvim_get_current_buf(), desc = 'Debug: Start/Continue' })

vim.keymap.set('n', '<leader>ca', function()
  vim.cmd.RustLsp 'codeAction'
end, { buffer = vim.api.nvim_get_current_buf(), desc = '[C]ode [A]ction' })

vim.g.rustaceanvim = {
  tools = {
    code_actions = {
      ui_select_fallback = false,
    },
  },
  server = {
    on_attach = function(_, _) end,
    default_settings = {
      ['rust-analyzer'] = {},
    },
  },
  dap = {},
}
