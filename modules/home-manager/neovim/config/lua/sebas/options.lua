local data_dir = vim.fn.stdpath 'data'

-- set backup, swap and undo locations
vim.o.backupdir = data_dir .. '/backup//'
vim.o.directory = data_dir .. '/swap//'
vim.o.undodir = data_dir .. '/undo//'
vim.o.undofile = true -- save  undotrees in files

for _, name in pairs { 'backupdir', 'directory', 'undodir' } do
  local dirname = vim.api.nvim_get_option(name)
  if vim.fn.isdirectory(dirname) == 0 then
    vim.fn.mkdir(dirname, 'p')
  end
end

vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true

vim.wo.signcolumn = 'yes'

vim.wo.number = true
vim.wo.relativenumber = true

vim.o.mouse = 'a'

vim.o.smartcase = true
vim.o.ignorecase = true

vim.o.hlsearch = false

vim.wo.wrap = true
vim.wo.breakindent = true
vim.wo.showbreak = string.rep(' ', 3) -- Make it so that long lines wrap smartly
vim.wo.linebreak = true

-- use 2 spaces instead of tab (to replace existing tab use :retab)
-- copy indent from current line when starting a new line
vim.bo.smartindent = true
vim.bo.expandtab = true
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.o.wrap = false

-- popup menu options
vim.o.pumblend = 17
vim.o.wildmode = 'longest:full'
vim.o.wildoptions = 'pum'

vim.o.title = true

vim.wo.colorcolumn = '81,121'

vim.o.showmode = false
vim.o.showcmd = true
vim.o.cmdheight = 1 -- Height of the command bar
vim.o.incsearch = true -- Makes search act like search in modern browsers
vim.o.showmatch = true -- show matching brackets when text indicator is over them

-- vim.o.hidden = true -- I like having buffers stay around
vim.wo.cursorline = true -- Highlight the current line

vim.o.splitright = true -- Prefer windows splitting to the right
vim.o.splitbelow = true -- Prefer windows splitting to the bottom

vim.o.updatetime = 250 -- Make updates happen faster
vim.o.timeout = true
vim.o.timeoutlen = 500

vim.o.scrolloff = 10 -- Make it so there are always ten lines below my cursor

-- Tabs
vim.bo.autoindent = true
vim.bo.cindent = true
vim.wo.wrap = true

vim.bo.spelllang = 'en,es,de,sv'

vim.o.belloff = 'all' -- Just turn the dang bell off

if not vim.fn.has 'macunix' then
  vim.o.clipboard = 'unnamed' -- linux secondary clipboard
end

vim.o.inccommand = 'split'
vim.opt.shada = { '!', "'1000", '<50', 's10', 'h' }

-- Helpful related items:
--   1. :center, :left, :right
--   2. gw{motion} - Put cursor back after formatting motion.
--
-- TODO: w, {v, b, l}
vim.opt_local.formatoptions:remove 'a' -- Auto formatting is BAD.
vim.opt_local.formatoptions:remove 't' -- Don't auto format my code. I got linters for that.
vim.opt_local.formatoptions:append 'c' -- In general, I like it when comments respect textwidth
vim.opt_local.formatoptions:append 'q' -- Allow formatting comments w/ gq
vim.opt_local.formatoptions:remove 'o' -- O and o, don't continue comments
vim.opt_local.formatoptions:append 'r' -- But do continue when pressing enter.
vim.opt_local.formatoptions:append 'n' -- Indent past the formatlistpat, not underneath it.
vim.opt_local.formatoptions:append 'j' -- Auto-remove comments if possible.
vim.opt_local.formatoptions:remove '2' -- I'm not in gradeschool anymore

-- set joinspaces
vim.o.joinspaces = false -- Two spaces and grade school, we're done

-- set fillchars=eob:~
vim.opt.fillchars = { eob = '~' }
