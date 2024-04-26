return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim',
  },
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup {
      mappings = {
        add = 'Sa',
        delete = 'Sd',
        find = 'Sf',
        find_left = 'SF',
        highlight = 'Sh',
        replace = 'Sr',
        update_n_lines = 'Sn',
      },
    }
  end,
}
