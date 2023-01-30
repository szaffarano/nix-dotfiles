-- Gitsigns
-- See `:help gitsigns.txt`
local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
	print("gitsigns plugin is not installed")
	return
end

gitsigns.setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})
