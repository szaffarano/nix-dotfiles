local ok, neodev
ok, _ = pcall(require, 'lspconfig')
if not ok then
  print 'lspconfig plugin is not installed'
  return
end

ok, neodev = pcall(require, 'neodev')
if ok then
  neodev.setup {}
end

require 'sebas.lsp.mason'
require('sebas.lsp.handlers').setup()
