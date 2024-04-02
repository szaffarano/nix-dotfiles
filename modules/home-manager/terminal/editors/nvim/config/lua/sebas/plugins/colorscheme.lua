return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    enabled = false,
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    enabled = true,
    init = function()
      vim.cmd.colorscheme 'kanagawa'
    end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    enabled = false,
    opts = {
      flavour = 'frappe', -- latte, frappe, macchiato, mocha
    },
    init = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
