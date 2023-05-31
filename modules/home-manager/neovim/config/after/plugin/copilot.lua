local ok, copilot = pcall(require, 'copilot')
if not ok then
  print 'copilot not installed'
  return
end

require('copilot_cmp').setup()
copilot.setup {
  suggestion = { enabled = false },
  panel = { enabled = false },
}
