local ok, blankline = pcall(require, 'indent_blankline')
if not ok then
  print 'indent_plankline plugin is not installed'
  return
end

blankline.setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}
