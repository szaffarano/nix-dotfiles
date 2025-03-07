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

local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set('n', '<F9>', run_debugger, { buffer = bufnr, desc = 'Debug: Start/Continue' })

vim.keymap.set('n', '<leader>ca', function()
  vim.cmd.RustLsp 'codeAction'
end, { buffer = bufnr, desc = '[C]ode [A]ction (Rust)' })

vim.keymap.set('n', 'K', function()
  vim.cmd.RustLsp { 'hover', 'actions' }
end, { buffer = bufnr, desc = 'Hover Documentation (Rust)' })

vim.keymap.set('n', '<leader>e', function()
  vim.cmd.RustLsp { 'renderDiagnostic', 'current' }
end, { buffer = bufnr, desc = 'Show diagnostic [E]rror messages (Rust)' })

vim.keymap.set('n', '<leader>E', function()
  vim.cmd.RustLsp { 'explainError', 'current' }
end, { buffer = bufnr, desc = 'Explain [E]rror (Rust)' })

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  callback = function()
    vim.diagnostic.setqflist { open = false }
  end,
})

-- mappings to review:
-- vim.cmd.RustLsp('relatedDiagnostics')
-- vim.cmd.RustLsp('openCargo')
-- vim.cmd.RustLsp('openDocs')
-- vim.cmd.RustLsp('joinLines'):qa
