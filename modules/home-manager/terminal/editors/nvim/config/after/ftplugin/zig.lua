local function apply_code_action(kind)
  local params = vim.lsp.util.make_range_params(0, 'utf-16')
  params.context = { only = { kind }, diagnostics = {} }
  local results = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 500)
  for _, res in pairs(results or {}) do
    for _, action in pairs(res.result or {}) do
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, 'utf-16')
      elseif type(action.command) == 'table' then
        vim.lsp.buf.execute_command(action.command)
      end
    end
  end
end

vim.api.nvim_create_autocmd('BufWritePre', {
  buffer = 0,
  callback = function()
    apply_code_action 'source.fixAll'
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  buffer = 0,
  callback = function()
    apply_code_action 'source.organizeImports'
  end,
})
