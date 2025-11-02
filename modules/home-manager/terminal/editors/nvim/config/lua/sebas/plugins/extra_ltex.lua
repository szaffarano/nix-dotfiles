return {
  'barreiroleo/ltex_extra.nvim',
  branch = 'dev',
  ft = {
    'gitcommit',
    'mail',
    'markdown',
    'mdx',
    'org',
    'pandoc',
    'rst',
    'tex',
  },
  dependencies = { 'neovim/nvim-lspconfig' },
  opts = {
    load_langs = { 'en-US', 'es-AR' },
    path = vim.fn.expand '$HOME/Documents/dict',
    log_level = 'info',
  },
}
