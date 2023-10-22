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
