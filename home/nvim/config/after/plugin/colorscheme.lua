local ok, lualine, catppuccin
ok, lualine = pcall(require, "lualine")
if not ok then
	print("lualine plugin is not installed")
	return
end
ok, catppuccin = pcall(require, "catppuccin")
if not ok then
	print("catppuccin plugin is not installed")
	return
end

catppuccin.setup({
	flavour = "frappe", -- mocha, macchiato, frappe, latte
})

vim.o.termguicolors = true
vim.cmd([[ colorscheme catppuccin ]])

-- Set lualine as statusline
-- See `:help lualine.txt`
lualine.setup({
	options = {
		icons_enabled = false,
		theme = "catppuccin",
		component_separators = "|",
		section_separators = "",
	},
})
