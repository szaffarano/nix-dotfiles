return {
  'folke/sidekick.nvim',

  enabled = true,

  opts = {
    cli = {
      mux = {
        backend = 'tmux',
        enabled = true,
      },
      tools = {
        claude = {
          cmd = { 'mise', 'exec', 'node@lts', '--', 'claude' },
        },
      },
      prompts = {
        diagnostics_mcp = 'Use mcp nvim to fix the diagnostics in connected nvim, buffer {file} (check resources, use code actions if available)',
        diagnostics_mcp_all = 'Use mcp nvim to fix the diagnostics in connected nvim in all quickfixes reported by LSP (check resources, use code actions if available)',
      },
    },
  },

  keys = {
    {
      '<tab>',
      function()
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>'
        end
      end,
      expr = true,
      desc = 'Goto/Apply Next Edit Suggestion',
    },
    {
      '<leader>aa',
      function()
        require('sidekick.cli').toggle()
      end,
      desc = 'Sidekick Toggle CLI',
    },
    {
      '<leader>as',
      function()
        require('sidekick.cli').select { filter = { installed = true } }
      end,
      desc = 'Select CLI',
    },
    {
      '<leader>at',
      function()
        require('sidekick.cli').send { msg = '{this}' }
      end,
      mode = { 'x', 'n' },
      desc = 'Send This',
    },
    {
      '<leader>av',
      function()
        require('sidekick.cli').send { msg = '{selection}' }
      end,
      mode = { 'x' },
      desc = 'Send Visual Selection',
    },
    {
      '<leader>ap',
      function()
        require('sidekick.cli').prompt()
      end,
      mode = { 'n', 'x' },
      desc = 'Sidekick Select Prompt',
    },
    {
      '<a-.>',
      function()
        require('sidekick.cli').focus()
      end,
      mode = { 'n', 'x', 'i', 't' },
      desc = 'Sidekick Switch Focus',
    },
    {
      '<leader>ac',
      function()
        require('sidekick.cli').toggle { name = 'claude', focus = true }
      end,
      desc = 'Sidekick Toggle Claude',
    },
  },
}
