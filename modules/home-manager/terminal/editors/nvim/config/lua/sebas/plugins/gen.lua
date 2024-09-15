return {
  'David-Kunz/gen.nvim',
  enable = false,
  opts = {
    model = 'mistral',
    display_mode = 'split',
    show_model = 'true',
    init = '',
  },
  keys = {
    {
      '<leader>l',
      ':Gen<CR>',
      mode = { 'n', 'v' },
      desc = 'Open up O[L]lama',
    },
  },
}
