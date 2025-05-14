return {
  'Exafunction/windsurf.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'saghen/blink.compat',
  },
  enabled = true,
  event = 'BufEnter',
  config = function()
    require('codeium').setup { enable_cmp_source = false, enable_chat = true }
  end,
}
