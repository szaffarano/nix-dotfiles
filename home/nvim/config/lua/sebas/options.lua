local data_dir = vim.fn.stdpath("data")

-- set backup, swap and undo locations
vim.opt.backupdir = data_dir .. "/backup//"
vim.opt.directory = data_dir .. "/swap//"
vim.opt.undodir = data_dir .. "/undo//"
vim.opt.undofile = true -- save  undotrees in files

for _, name in pairs({ "backupdir", "directory", "undodir" }) do
	local dirname = vim.api.nvim_get_option(name)
	if vim.fn.isdirectory(dirname) == 0 then
		vim.fn.mkdir(dirname, "p")
	end
end

vim.o.completeopt = "menuone,noselect"

vim.wo.signcolumn = "yes"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.hlsearch = false

vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
vim.opt.linebreak = true

-- use 2 spaces instead of tab (to replace existing tab use :retab)
-- copy indent from current line when starting a new line
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.wrap = false

-- Ignore compiled files
vim.opt.wildignore = "__pycache__"
vim.opt.wildignore = vim.opt.wildignore + { "*.o", "*~", "*.pyc", "*pycache*" }

vim.opt.pumblend = 17
vim.opt.wildmode = "longest:full"
vim.opt.wildoptions = "pum"

vim.opt.colorcolumn = "80,120"

vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1 -- Height of the command bar
vim.opt.incsearch = true -- Makes search act like search in modern browsers
vim.opt.showmatch = true -- show matching brackets when text indicator is over them

vim.opt.hidden = true -- I like having buffers stay around
vim.opt.cursorline = true -- Highlight the current line

vim.opt.splitright = true -- Prefer windows splitting to the right
vim.opt.splitbelow = true -- Prefer windows splitting to the bottom

vim.opt.updatetime = 250 -- Make updates happen faster
vim.opt.scrolloff = 10 -- Make it so there are always ten lines below my cursor
vim.opt.timeoutlen = 500

-- Tabs
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.wrap = true

vim.opt.spelllang = "en,es,de,sv"

vim.opt.belloff = "all" -- Just turn the dang bell off

if not vim.fn.has("macunix") then
	vim.opt.clipboard = "unnamed" -- linux secondary clipboard
end

vim.opt.inccommand = "split"
vim.opt.shada = { "!", "'1000", "<50", "s10", "h" }

-- Helpful related items:
--   1. :center, :left, :right
--   2. gw{motion} - Put cursor back after formatting motion.
--
-- TODO: w, {v, b, l}
vim.opt.formatoptions:remove("a") -- Auto formatting is BAD.
vim.opt.formatoptions:remove("t") -- Don't auto format my code. I got linters for that.
vim.opt.formatoptions:append("c") -- In general, I like it when comments respect textwidth
vim.opt.formatoptions:append("q") -- Allow formatting comments w/ gq
vim.opt.formatoptions:remove("o") -- O and o, don't continue comments
vim.opt.formatoptions:append("r") -- But do continue when pressing enter.
vim.opt.formatoptions:append("n") -- Indent past the formatlistpat, not underneath it.
vim.opt.formatoptions:append("j") -- Auto-remove comments if possible.
vim.opt.formatoptions:remove("2") -- I'm not in gradeschool anymore

-- set joinspaces
vim.opt.joinspaces = false -- Two spaces and grade school, we're done

-- set fillchars=eob:~
vim.opt.fillchars = { eob = "~" }
