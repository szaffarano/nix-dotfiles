-- [[ Initial options ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- needed here to make orgmode integration work
-- TODO: use common config taken from  nvim-orgmode
vim.g.wiki_root = '~/Documents/org'
vim.g.wiki_filetypes = { 'org' }

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)
