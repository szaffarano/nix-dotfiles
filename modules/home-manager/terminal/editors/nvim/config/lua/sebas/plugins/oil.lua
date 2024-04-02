return { --  A vim-vinegar like file explorer that lets you edit your filesystem like a normal Neovim buffer.
  'stevearc/oil.nvim',
  lazy = false,
  opts = {
    -- set to false to make some netrw-dependant plugins to work
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      natural_order = false,
    },
  },
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Oil' },
  },
}
