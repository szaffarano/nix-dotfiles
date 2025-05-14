return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    enabled = true,
    config = function()
      require('copilot').setup {
        suggestion = { enabled = false },
        panel = { enabled = false },
        copilot_node_command = vim.fn.expand '$HOME' .. '/.local/share/mise/shims/node',
        filetypes = {
          markdown = true,
          help = true,
        },
      }
    end,
  },
}
