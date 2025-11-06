local ltex_utils = require 'sebas.utils.ltex'

return {
  'barreiroleo/ltex_extra.nvim',
  branch = 'dev',
  ft = ltex_utils.filetypes,
  dependencies = { 'neovim/nvim-lspconfig' },
  opts = {
    load_langs = { 'en-US', 'es-AR' },
    path = vim.fn.expand '$HOME/Documents/dict',
    log_level = 'error',
  },
}
