return {
  'rcarriga/nvim-notify',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = false,
  config = function()
    local notify = require 'notify'
    local log = require('plenary.log').new {
      plugin = 'notify',
      level = 'debug',
      use_console = false,
    }

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify = function(msg, level, opts)
      log.info(msg, level, opts)
      notify(msg, level, opts)
    end
  end,
}
