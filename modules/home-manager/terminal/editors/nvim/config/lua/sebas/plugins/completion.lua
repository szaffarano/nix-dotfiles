return {
  {
    'saghen/blink.compat',
    version = '*',
    lazy = true,
    opts = { enable_events = true },
  },
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets', 'fang2hou/blink-copilot' },
    version = '1.*',
    build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'default' },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = { auto_show = true },
      },

      signature = { enabled = true },

      sources = {
        default = { 'avante', 'lsp', 'path', 'snippets', 'buffer', 'copilot', 'codeium', 'orgmode' },
        providers = {
          copilot = { name = 'Copilot', module = 'blink-copilot', score_offset = 100, async = true },
          codeium = { name = 'Codeium', module = 'codeium.blink', score_offset = 100, async = true },
          orgmode = { name = 'Orgmode', module = 'orgmode.org.autocompletion.blink', fallbacks = { 'buffer' } },
          avante = { name = 'Avante', module = 'blink-cmp-avante' },
        },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
