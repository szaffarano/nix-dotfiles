local ok, oil = pcall(require, 'oil')
if not ok then
  print 'oil not installed'
  return
end

oil.setup {}

vim.keymap.set('n', '-', require('oil').open, { desc = 'Open parent directory' })
