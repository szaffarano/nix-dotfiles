require 'sebas.bootstrap'

local is_vscode = vim.g.vscode ~= nil

vim.g.base16_colorspace = 256
vim.g.base16_background_transparent = 1

local ok, lazy = pcall(require, 'lazy')
if ok then
  lazy.setup('sebas.plugins', {
    change_detection = {
      notify = false,
    },
  })
else
  print 'lazy.nvim not found'
end
