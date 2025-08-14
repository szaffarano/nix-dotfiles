return {
  {
    'saghen/blink.compat',
    version = '*',
    lazy = true,
    opts = { enable_events = true },
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'fang2hou/blink-copilot',
    },
    version = '1.*',
    build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      cmdline = {
        enabled = true,
        keymap = { preset = 'cmdline', ['<Tab>'] = false },
        sources = { 'buffer', 'cmdline' },
      },

      keymap = { preset = 'default' },

      appearance = { nerd_font_variant = 'mono' },

      completion = {
        documentation = { auto_show = true },

        menu = {
          draw = {
            columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind' } },
          },
        },
      },

      signature = { enabled = true },

      sources = {
        default = {
          'lsp',
          'path',
          'snippets',
          'buffer',
          'copilot',
          'orgmode',
        },
        providers = {
          copilot = { name = 'Copilot', module = 'blink-copilot', score_offset = 300, async = true },
          orgmode = { name = 'Orgmode', module = 'orgmode.org.autocompletion.blink', fallbacks = { 'buffer' } },
        },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
