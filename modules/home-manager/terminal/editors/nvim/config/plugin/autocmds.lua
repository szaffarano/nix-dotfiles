-- [[ Basic Autocommands ]]

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Enable spellcheck for some filetypes
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable spelcheck on some file types',
  group = vim.api.nvim_create_augroup('enable-spell-check', { clear = true }),
  pattern = {
    'tex',
    'latex',
    'markdown',
    'org',
  },
  command = 'setlocal spell spelllang=en,es',
})

-- orgmode
local g = vim.api.nvim_create_augroup('init_orgmode', { clear = true })
-- Conceal mode for org files
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Set conceal mode properly',
  group = g,
  pattern = {
    'org',
  },
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = 'nc'
    vim.opt_local.foldenable = false
  end,
})

-- wiki
local g = vim.api.nvim_create_augroup('init_wiki', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = g,
  pattern = 'WikiLinkFollowed',
  desc = 'Wiki: Center view on link follow',
  command = [[ normal! zz ]],
})

vim.api.nvim_create_autocmd('User', {
  group = g,
  pattern = 'WikiBufferInitialized',
  desc = 'Wiki: add mapping for gf',
  command = [[ nmap <buffer> gf <plug>(wiki-link-follow) ]],
})
