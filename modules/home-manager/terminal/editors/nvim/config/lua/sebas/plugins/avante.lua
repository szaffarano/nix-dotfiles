return {
  'yetone/avante.nvim',
  build = 'make',
  event = 'VeryLazy',
  version = false,
  ---@module 'avante'
  ---@type avante.Config
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    -- add any opts here
    -- for example
    provider = 'claude',
    selector = {
      provider = 'telescope',
    },
    providers = {
      claude = {
        endpoint = 'https://api.anthropic.com',
        model = 'claude-sonnet-4-20250514',
        api_key_name = 'cmd:get-keepass-entry cli "https://anthropic.com" ',
        timeout = 30000,
      },
    },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua',
    'Kaiser-Yang/blink-cmp-avante',
  },
}
