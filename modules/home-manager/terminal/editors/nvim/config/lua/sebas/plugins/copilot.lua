return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    enabled = false,
    config = function()
      require('copilot').setup {
        suggestion = {
          -- use cmp-copilot instead
          enabled = false,
        },
        panel = {
          -- use cmp-copilot instead
          enabled = false,
        },
        copilot_node_command = vim.fn.expand '$HOME' .. '/.local/share/mise/installs/node/lts/bin/node',
      }
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup()
    end,
  },
}
