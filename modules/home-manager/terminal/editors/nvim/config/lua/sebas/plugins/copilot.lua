return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    enabled = true,
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
        copilot_node_command = vim.fn.expand '$HOME' .. '/.local/share/mise/shims/node',
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
