local file_types = { 'markdown', 'codecompanion', 'Avante' }

return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { { 'nvim-treesitter/nvim-treesitter', branch = 'main' }, 'nvim-tree/nvim-web-devicons' },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    completions = { lsp = { enabled = true }, blink = { enabled = true } },
    file_types = file_types,
    restart_highlighter = true,
    code = {
      border = 'thin',
      sign = false,
      width = 'block',
      min_width = 78,
    },
    heading = {
      sign = false,
      width = 'block',
    },
    indent = {
      enable = true,
    },
  },
  ft = file_types,
  init = function()
    -- Map .mdx extension directly to markdown so LSP/treesitter/render-markdown
    -- all activate without an intermediate 'mdx' filetype and the compound
    -- 'markdown.mdx' health-check warning.
    vim.filetype.add { extension = { mdx = 'markdown' } }
  end,
  keys = {
    { '<F3>', '<CMD>RenderMarkdown toggle<CR>', desc = 'Render Markdown' },
  },
}
