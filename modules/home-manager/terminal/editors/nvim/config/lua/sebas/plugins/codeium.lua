return {
  'Exafunction/windsurf.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'saghen/blink.compat',
  },
  enabled = false,
  event = 'BufEnter',
  config = function()
    require('codeium').setup {
      enable_cmp_source = false,
      enable_chat = true,
    }
  end,
}
