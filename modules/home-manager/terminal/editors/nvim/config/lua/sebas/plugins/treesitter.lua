return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    auto_install = false,
    ensure_installed = {},
    highlight = {
      enable = true,
    },
    indent = { enable = true },
  },
}
