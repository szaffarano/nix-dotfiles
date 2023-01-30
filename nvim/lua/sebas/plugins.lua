local M = {}

local ok, packer = pcall(require, "packer")
if not ok then
	print("packer plugin is not installed")
	return M
end

function M.setup(is_bootstrap)
	local conf = {
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "rounded" })
			end,
		},
	}

	local function plugins(use)
		use("wbthomason/packer.nvim")

		use({
			"neovim/nvim-lspconfig",
			requires = {
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",

				"j-hui/fidget.nvim",
			},
		})
		use("folke/neodev.nvim")

		use({
			"hrsh7th/nvim-cmp",
			requires = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lsp-document-symbol",
				"saadparwaiz1/cmp_luasnip",
				"tamago324/cmp-zsh",
			},
		})

		use({
			"nvim-treesitter/nvim-treesitter",
			run = function()
				pcall(require("nvim-treesitter.install").update({ with_sync = true }))
			end,
		})
		use({ "nvim-treesitter/nvim-treesitter-textobjects", after = { "nvim-treesitter" } })

		use("tpope/vim-fugitive")
		use("tpope/vim-rhubarb")
		use("lewis6991/gitsigns.nvim")

		-- Speed up loading Lua modules in Neovim to improve startup time.
		use("lewis6991/impatient.nvim")

		-- GnuPG transparent encryption
		use("jamessan/vim-gnupg")

		use("numToStr/Comment.nvim")

		-- Snippet Engine and Snippet Expansion
		use({ "L3MON4D3/LuaSnip", requires = { "saadparwaiz1/cmp_luasnip" } })
		use("rafamadriz/friendly-snippets")

		use("tpope/vim-unimpaired") -- Useful mappings

		use("godlygeek/tabular") -- Alignment

		use("farmergreg/vim-lastplace") -- reopen files at last edites positions

		use("catppuccin/nvim")

		use("nvim-lualine/lualine.nvim") -- Fancier statusline

		use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines

		use("tpope/vim-sleuth") -- Detect tabstop and shiftwidth automatically

		use({ "nvim-telescope/telescope.nvim", branch = "0.1.x", requires = { "nvim-lua/plenary.nvim" } })
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable("make") == 1 })

		-- Automatically highlighting other uses of the word under the cursor
		use("RRethy/vim-illuminate")

		use("ray-x/go.nvim")
		use("ray-x/guihua.lua")
		use("mfussenegger/nvim-dap")
		use("rcarriga/nvim-dap-ui")
		use("theHamsta/nvim-dap-virtual-text")

		use("sbdchd/neoformat")

		if is_bootstrap then
			packer.sync()
		end
	end

	local reloadPlugins = function()
		vim.cmd([[ source $MYVIMRC ]])
		require("plenary.reload").reload_module("sebas.plugins")
		packer.sync()
		packer.compile()
	end

	-- Automatically source and re-compile packer whenever you save this init.lua
	local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePost", {
		callback = reloadPlugins,
		group = packer_group,
		pattern = "*/sebas/plugins.lua",
	})

	packer.init(conf)
	packer.reset()
	packer.startup(plugins)
end

return M
