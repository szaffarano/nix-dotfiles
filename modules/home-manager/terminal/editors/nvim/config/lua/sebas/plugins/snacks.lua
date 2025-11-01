return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    input = {
      b = {
        completion = true,
      },
    },
    picker = {},
    notifier = {},
  },
  config = function(_, opts)
    require('snacks').setup(opts)
    Snacks.keymap.set('n', '<localleader>ll', Snacks.notifier.hide, {
      desc = 'Notifier Hide',
    })
    Snacks.keymap.set('n', '<localleader>lh', Snacks.notifier.show_history, {
      desc = 'Notifier get History',
    })
  end,
}
