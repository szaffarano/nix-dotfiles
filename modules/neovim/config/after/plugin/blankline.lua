local ok, blankline = pcall(require, "indent_blankline")
if not ok then
	print("blankline plugin is not installed")
	return
end

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
blankline.setup({
	char = "┊",
	show_trailing_blankline_indent = false,
})
