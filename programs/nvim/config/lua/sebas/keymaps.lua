vim.keymap.set("n", "<leader>w", "<cmd>write<cr>")
vim.keymap.set({ "n", "x", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "x", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "x", "v" }, "<leader>d", '"+d')

vim.keymap.set("v", "p", '"_dP', { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
	group = highlight_group,
	pattern = "*",
})

-- [[ Toggle relative numbers when enter in insert mode ]]
local relative_numbers_group = vim.api.nvim_create_augroup("LineNumbers", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.opt_local.relativenumber = false
	end,
	group = relative_numbers_group,
	pattern = "*",
})
vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function()
		vim.opt_local.relativenumber = true
	end,
	group = relative_numbers_group,
	pattern = "*",
})

-- " relative / hybrid line number switch
-- augroup toggle_relative_numbers
--   autocmd InsertEnter * :setlocal norelativenumber
--   autocmd InsertLeave * :setlocal relativenumber
-- augroup end

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

vim.keymap.set("i", "<Up>", "<Nop>", { noremap = true })
vim.keymap.set("i", "<Down>", "<Nop>", { noremap = true })
vim.keymap.set("i", "<Left>", "<Nop>", { noremap = true })
vim.keymap.set("i", "<Right>", "<Nop>", { noremap = true })

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

vim.keymap.set("n", "<A-h>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-l>", ":vertical resize +2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-j>", ":resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", ":resize +2<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<Esc>", "<Cmd>noh<Cr>", { noremap = true, silent = true })

-- move between tabs and buffers
vim.keymap.set("n", "<C-Left>", "<Cmd>tabprev<CR> <Cmd>redraw!<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<C-Right>", "<Cmd>tabnext<CR> <Cmd>redraw!<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<Left>", "<Cmd>bp<CR> <Cmd>redraw!<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<Right>", "<Cmd>bn<CR> <Cmd>redraw!<CR>", { silent = true, noremap = true })

-- toggles the paste mode
vim.keymap.set("n", "<C-p>", "<Cmd>set paste!<CR>")

-- disable annoying ex mode
vim.keymap.set("n", "Q", "<Nop>", { noremap = true })

-- reload vimrc configuration file
vim.keymap.set("n", "<Leader>vr", "<Cmd>source $MYVIMRC<CR>", { noremap = true })

-- toggle spelling
vim.keymap.set({ "n", "i" }, "<F12>", "<Cmd>set spell!<cr>", { silent = true, noremap = true })

-- go to previous buffer
vim.keymap.set("n", "<leader><Leader>", "<C-^>", { silent = true, noremap = true })

-- close current buffer
vim.keymap.set("n", "<leader>d", "<Cmd>bdel<CR>", { silent = true, noremap = true })

vim.keymap.set("n", "<leader>g", "<Cmd>Git<CR>", { noremap = true })
