local ok, cmp, luasnip
ok, cmp = pcall(require, 'cmp')
if not ok then
  return
end
ok, luasnip = pcall(require, 'luasnip')
if not ok then
  return
end

require('luasnip/loaders/from_vscode').lazy_load()

luasnip.config.setup {}

cmp.setup {
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  mapping = cmp.mapping.preset.insert {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),

    ['<CR>'] = cmp.mapping.confirm { select = true },
  },

  sources = {
    { name = 'buffer', keyword_length = 5 },
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'treesitter' },
  },
}
