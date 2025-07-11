vim.filetype.add {
  extension = { mdx = 'mdx' },
}
vim.treesitter.language.register('markdown', 'mdx')

local file_types = { 'markdown', 'mdx', 'codecompanion', 'Avante' }

return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    completions = { lsp = { enabled = true } },
    file_types = file_types,
  },
  ft = file_types,
}
