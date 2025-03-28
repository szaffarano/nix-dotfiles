-- [[ Basic Keymaps ]]

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copy to OS clipboard' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste from OS clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"+d', { desc = 'Delete and copy to OS clipboard' })

-- move cursor in insert mode using ctrl-alt-...
vim.keymap.set({ 'i', 'c' }, '<C-M-h>', '<Left>', { desc = 'Move to the left in insert mode' })
vim.keymap.set({ 'i', 'c' }, '<C-M-l>', '<Right>', { desc = 'Move to the right in insert mode' })
vim.keymap.set({ 'i', 'c' }, '<C-M-j>', '<Down>', { desc = 'Move down in insert mode' })
vim.keymap.set({ 'i', 'c' }, '<C-M-k>', '<Up>', { desc = 'Move up in insert mode' })

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Use arrow keys to move between buffers
vim.keymap.set('n', '<Left>', '<Cmd>bp<CR> <Cmd>redraw!<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<Right>', '<Cmd>bn<CR> <Cmd>redraw!<CR>', { desc = 'Next buffer' })

-- Use ctrl + arrow keys to move between tabs
vim.keymap.set('n', '<C-Left>', '<Cmd>tabprev<CR> <Cmd>redraw!<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', '<C-Right>', '<Cmd>tabnext<CR> <Cmd>redraw!<CR>', { desc = 'Next tab' })

vim.keymap.set({ 'n', 'v' }, '<C-x>', '<Cmd>bdelete<CR>', { desc = 'Delete current buffer' })

vim.keymap.set({ 'x' }, 'p', 'pgvy', { desc = 'Retain the buffer content after pasting over a visual selection' })

function ToggleQuickfix()
  local windows = vim.fn.getwininfo()
  for _, win in ipairs(windows) do
    if win.quickfix == 1 then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end

vim.api.nvim_set_keymap('n', '<leader>q', ':lua ToggleQuickfix()<CR>', { noremap = true, silent = true })
