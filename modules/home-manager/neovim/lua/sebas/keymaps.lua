-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Goto prev diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Goto next diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open float diagnostic' })
vim.keymap.set('n', '<leader>E', vim.diagnostic.setloclist, { desc = 'Show diagnostic buffer' })


-- move between tabs and buffers
vim.keymap.set('n', '<C-Left>', '<Cmd>tabprev<CR> <Cmd>redraw!<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<C-Right>', '<Cmd>tabnext<CR> <Cmd>redraw!<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<Left>', '<Cmd>bp<CR> <Cmd>redraw!<CR>', { silent = true, noremap = true })
vim.keymap.set('n', '<Right>', '<Cmd>bn<CR> <Cmd>redraw!<CR>', { silent = true, noremap = true })

vim.keymap.set('n', '<leader>g', '<Cmd>Git<CR>', { noremap = true, desc = 'Open fugitive' })
