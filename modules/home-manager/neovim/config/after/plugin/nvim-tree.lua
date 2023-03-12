local ok, nvim_tree = pcall(require, 'nvim-tree')
if not ok then
  print 'nvim-tree not installed'
  return
end

nvim_tree.setup()

vim.keymap.set('n', '<leader>fo', '<Cmd>NvimTreeToggle<CR>', { desc = 'Open file tree' })
vim.keymap.set('n', '<A-o>', '<Cmd>NvimTreeToggle<CR>', { desc = 'Open file tree' })
