return {
  on_attach = function(_, bufnr)
    -- TODO add shortcut to toggle inlay hints
    vim.lsp.inlay_hint.enable(bufnr)
  end,
}
