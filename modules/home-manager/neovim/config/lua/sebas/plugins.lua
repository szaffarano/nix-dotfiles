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
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}

lazy.setup({
  -- git
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'lewis6991/gitsigns.nvim',

  -- manage shiftwitd and expand tab automagically
  'tpope/vim-sleuth',

  -- LSP stuff
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', branch = 'legacy', opts = {} },
      'folke/neodev.nvim',
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'ray-x/cmp-treesitter',
      'saadparwaiz1/cmp_luasnip',
      'tamago324/cmp-zsh',
    },
  },
  'rafamadriz/friendly-snippets',

  'folke/which-key.nvim',

  'catppuccin/nvim',
  'folke/tokyonight.nvim',

  'nvim-lualine/lualine.nvim',

  'lukas-reineke/indent-blankline.nvim',

  'numToStr/Comment.nvim',
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- automatic higlighting
  'RRethy/vim-illuminate',

  -- transparent gpg encryption
  'jamessan/vim-gnupg',

  -- misc goodies
  'tpope/vim-unimpaired',
  'godlygeek/tabular',
  'farmergreg/vim-lastplace',

  -- A vim-vinegar like file explorer that lets you edit your filesystem like a normal Neovim buffer.
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  'sbdchd/neoformat',

  -- embedded terms
  { 'akinsho/toggleterm.nvim', version = '*', config = true },

  {
    'nvim-orgmode/orgmode',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  'akinsho/org-bullets.nvim',
  'lervag/wiki.vim',

  'itchyny/calendar.vim',

  {
    'zbirenbaum/copilot.lua',
    dependencies = { 'zbirenbaum/copilot-cmp' },
  },
}, lazy_config)
