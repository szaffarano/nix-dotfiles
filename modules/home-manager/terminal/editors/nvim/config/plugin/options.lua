-- [[ Setting options ]]

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = 'a'

vim.opt.showmode = false

vim.opt.clipboard = 'unnamed'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', conceal = '┊', eol = '↲', extends = '<', precedes = '>' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '80,120'
vim.opt.textwidth = 120

vim.opt.spelllang = 'en,es,de,sv'

-- Tab options
vim.opt.tabstop = 2 -- Number of spaces a <Tab> in the text stands for (local to buffer)
vim.opt.shiftwidth = 2 -- Number of spaces used for each step of (auto)indent (local to buffer)
vim.opt.softtabstop = 0 -- If non-zero, number of spaces to insert for a <Tab> (local to buffer)
vim.opt.expandtab = true -- Expand <Tab> to spaces in Insert mode (local to buffer)
vim.opt.autoindent = true -- Do clever autoindenting

vim.opt.wrap = false

vim.opt.swapfile = false -- Disable the swap file
vim.opt.modeline = true -- Tags such as 'vim:ft=sh'
vim.opt.modelines = 100 -- Sets the type of modelines
vim.opt.incsearch = true -- Incremental search: show match for partly typed search command
vim.opt.showmatch = true -- show matching brackets when text indicator is over them

vim.opt.hidden = true -- Keep closed buffer open in the background
vim.opt.mousemodel = 'extend' -- Mouse right-click extends the current selection

vim.opt.hlsearch = true
vim.opt.cursorcolumn = false -- Highlight the screen column of the cursor
vim.opt.laststatus = 3 -- When to use a status line for the last window
vim.opt.termguicolors = true -- Enables 24-bit RGB color in the |TUI|
vim.opt.spell = false -- Highlight spelling mistakes (local to window)
