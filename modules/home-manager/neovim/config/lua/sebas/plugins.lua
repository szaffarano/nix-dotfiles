local ok, lazy = pcall(require, 'lazy')
if not ok then
  print 'lazy plugin not installed'
  return
end

local lazy_config = {
  ui = {
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      source = '📄',
      start = '🚀',
      task = '📌',
    },
  },
}

lazy.setup({
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'lewis6991/gitsigns.nvim',
  'tpope/vim-sleuth',

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'folke/neodev.nvim',
      'j-hui/fidget.nvim',
    },
  },

  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'saadparwaiz1/cmp_luasnip',
      'tamago324/cmp-zsh',
      'ray-x/cmp-treesitter',
    },
  },

  { 'L3MON4D3/LuaSnip', requires = { 'saadparwaiz1/cmp_luasnip' } },
  'rafamadriz/friendly-snippets',

  'folke/which-key.nvim',

  'catppuccin/nvim',

  'nvim-lualine/lualine.nvim',

  'lukas-reineke/indent-blankline.nvim',

  'numToStr/Comment.nvim',
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },

  'RRethy/vim-illuminate',

  'jamessan/vim-gnupg',
  'tpope/vim-unimpaired',
  'godlygeek/tabular',
  'farmergreg/vim-lastplace',

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    'sbdchd/neoformat',
  },

  { 'akinsho/toggleterm.nvim', version = '*', config = true },
}, lazy_config)
