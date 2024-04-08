require 'sebas.bootstrap'

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

-- Update `runtimepath` with treesitter parsers configured by nix config
-- It has to be located here because `lazy` overrides `runtimepath`
local treesitter_parsers = vim.fn.stdpath 'data' .. '/treesitter-parsers'
vim.opt.runtimepath:append(treesitter_parsers)
