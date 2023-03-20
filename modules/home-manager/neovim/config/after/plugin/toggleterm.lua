local ok, toggleterm = pcall(require, 'toggleterm')
if not ok then
  print 'toggleterm plugin is not installed'
  return
end

toggleterm.setup {
  open_mapping = [[<c-\>]],
}
