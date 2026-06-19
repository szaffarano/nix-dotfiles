-- Auto-apply all fixable zls diagnostics on save
vim.api.nvim_create_autocmd('BufWritePre', {
  buffer = 0,
  callback = function()
    vim.lsp.buf.code_action {
      context = { only = { 'source.fixAll' }, diagnostics = {} },
      apply = true,
    }
  end,
})

-- Auto-sort imports on save
vim.api.nvim_create_autocmd('BufWritePre', {
  buffer = 0,
  callback = function()
    vim.lsp.buf.code_action {
      context = { only = { 'source.organizeImports' }, diagnostics = {} },
      apply = true,
    }
  end,
})
