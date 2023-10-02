local ok, ibl = pcall(require, 'ibl')
if not ok then
  print 'indent_plankline plugin is not installed'
  return
end

local highlight = {
  'CursorColumn',
  'Whitespace',
}

ibl.setup {
  indent = { highlight = highlight, char = '┊' },
  whitespace = {
    highlight = {
      'CursorColumn',
      'Whitespace',
    },
    remove_blankline_trail = false,
  },
  scope = { enabled = false },
}
