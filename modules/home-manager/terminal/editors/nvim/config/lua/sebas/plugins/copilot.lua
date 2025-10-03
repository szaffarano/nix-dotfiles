return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    enabled = false,
    config = function()
      require('copilot').setup {
        suggestion = { enabled = true },
        panel = { enabled = true },
        copilot_node_command = vim.fn.expand '$HOME' .. '/.local/bin/node-latest',
        filetypes = {
          markdown = true,
          help = true,
        },
      }
    end,
  },
}
