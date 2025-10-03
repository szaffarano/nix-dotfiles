return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
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
