vim.filetype.add {
  extension = { mdx = 'mdx' },
}
vim.treesitter.language.register('markdown', 'mdx')

return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    completions = { lsp = { enabled = true } },
    file_types = { 'markdown', 'mdx' },
  },
}
