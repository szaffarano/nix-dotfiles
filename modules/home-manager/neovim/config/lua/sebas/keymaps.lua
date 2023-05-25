vim.keymap.set({ 'n' }, '<leader>w', '<cmd>write<cr>', { desc = 'Save current buffer' })
vim.keymap.set({ 'n', 'x', 'v' }, '<leader>d', '"+d', { desc = 'Delete and copy to OS clipboard' })

vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copy to OS clipboard' })
vim.keymap.set('n', '<leader>Y', '"+yg_', { desc = 'Copy rest to OS clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste OS clipboard before' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste OS clipboard after' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '<cmd>bdelete<cr>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>D', '"_dd', { desc = 'Void line to void' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move block up' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move block down' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half-page up' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half-page down' })
vim.keymap.set('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Substitute' })

vim.keymap.set('v', 'p', '"_dP', { noremap = true, silent = true })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      timeout = 40,
    }
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Toggle relative numbers when enter in insert mode ]]
local relative_numbers_group = vim.api.nvim_create_augroup('LineNumbers', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    vim.opt_local.relativenumber = false
  end,
  group = relative_numbers_group,
  pattern = '*',
})
vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    vim.opt_local.relativenumber = true
  end,
  group = relative_numbers_group,
  pattern = '*',
})

-- " relative / hybrid line number switch
-- augroup toggle_relative_numbers
--   autocmd InsertEnter * :setlocal norelativenumber
--   autocmd InsertLeave * :setlocal relativenumber
-- augroup end

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Goto prev diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Goto next diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open float diagnostic' })
vim.keymap.set('n', '<leader>E', vim.diagnostic.setloclist, { desc = 'Show diagnostic buffer' })

vim.keymap.set('i', '<Up>', '<Nop>', { noremap = true })
vim.keymap.set('i', '<Down>', '<Nop>', { noremap = true })
vim.keymap.set('i', '<Left>', '<Nop>', { noremap = true })
vim.keymap.set('i', '<Right>', '<Nop>', { noremap = true })

vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

vim.keymap.set('n', '<A-h>', ':vertical resize +2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-l>', ':vertical resize -2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-j>', ':resize -2<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-k>', ':resize +2<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<Esc>', '<Cmd>noh<Cr>', { noremap = true, silent = true })

-- move between tabs and buffers
vim.keymap.set('n', '<C-Left>', '<Cmd>tabprev<CR> <Cmd>redraw!<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<C-Right>', '<Cmd>tabnext<CR> <Cmd>redraw!<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<Left>', '<Cmd>bp<CR> <Cmd>redraw!<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<Right>', '<Cmd>bn<CR> <Cmd>redraw!<CR>', { silent = true, noremap = true })

vim.keymap.set('n', 'Q', '<Nop>', { noremap = true })

vim.keymap.set(
  { 'n', 'i' },
  '<F12>',
  '<Cmd>set spell!<cr>',
  { silent = true, noremap = true, desc = 'Toggle spelling' }
)

vim.keymap.set('n', '<leader><Leader>', '<C-^>', { silent = true, noremap = true, desc = 'Go to previous buffer' })
vim.keymap.set('n', '<leader>q', '<Cmd>bdel<CR>', { silent = true, noremap = true, desc = 'Close current buffer' })
vim.keymap.set('n', '<leader>g', '<Cmd>Git<CR>', { noremap = true, desc = 'Open fugitive' })
