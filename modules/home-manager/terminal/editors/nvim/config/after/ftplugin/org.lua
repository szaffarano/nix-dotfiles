vim.opt_local.concealcursor = 'nc'
vim.opt_local.conceallevel = 2
vim.opt_local.foldenable = true
vim.opt_local.foldlevel = 99
vim.opt_local.foldlevelstart = 99

vim.keymap.set('n', '<localleader>oti', function()
  Org:indent_mode()
end, {
  buffer = true,
  desc = '[O]orgMode [T]oggle [I]ndent Mode',
})
