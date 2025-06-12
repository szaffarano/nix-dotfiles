return {
  'barreiroleo/ltex_extra.nvim',
  branch = 'dev',
  ft = { 'gitcommit', 'markdown', 'org', 'pandoc', 'plaintex', 'rmd', 'rst', 'tex', 'mdx', 'markdown', 'md' },
  dependencies = { 'neovim/nvim-lspconfig' },
  opts = {
    load_langs = { 'en-US', 'es-AR' },
    path = vim.fn.expand '$HOME/Documents/dict',
    log_level = 'info',
  },
}
