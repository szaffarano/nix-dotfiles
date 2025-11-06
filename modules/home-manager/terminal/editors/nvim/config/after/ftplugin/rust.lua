vim.opt_local.formatoptions:remove 'o'

local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set('n', '<leader>ca', function()
  vim.cmd.RustLsp 'codeAction'
end, { buffer = bufnr, desc = '[C]ode [A]ction' })

vim.keymap.set('n', '<leader>rd', function()
  vim.cmd.RustLsp 'relatedDiagnostics'
end, { buffer = bufnr, desc = '[R]ust related [D]iagnostics' })

vim.keymap.set('n', '<leader>rh', function()
  vim.cmd.RustLsp { 'hover', 'range' }
end, { buffer = bufnr, desc = '[R]ust [H]over range' })

vim.keymap.set('n', 'K', function()
  vim.cmd.RustLsp { 'hover', 'actions' }
end, { buffer = bufnr, desc = 'Hover Documentation (Rust)' })

vim.keymap.set('n', '<leader>re', function()
  vim.cmd.RustLsp { 'renderDiagnostic', 'current' }
end, { buffer = bufnr, desc = '[R]ust show diagnostic [E]rror messages' })

vim.keymap.set('n', '<leader>rE', function()
  vim.cmd.RustLsp { 'explainError', 'current' }
end, { buffer = bufnr, desc = '[R]ust explain [E]rror' })

vim.keymap.set('n', '<leader>rod', function()
  vim.cmd.RustLsp 'openDocs'
end, { buffer = bufnr, desc = '[R]ust [O]pen [D]ocs' })

vim.keymap.set('n', '<leader>rc', function()
  vim.cmd.RustLsp 'openCargo'
end, { buffer = bufnr, desc = '[R]ust open [C]argo.toml' })

vim.keymap.set('n', '<leader>rj', function()
  vim.cmd.RustLsp 'joinLines'
end, { buffer = bufnr, desc = '[R]ust [J]oin lines' })

local is_dap_installed, dap = pcall(require, 'dap')
if is_dap_installed then
  local function run_debugger()
    if dap.session() then
      dap.continue()
    else
      vim.cmd.RustLsp 'debuggables'
    end
  end

  vim.keymap.set('n', '<F9>', run_debugger, { buffer = bufnr, desc = 'Debug: Start/Continue' })
else
  print 'dap not found'
end
