require 'sebas.bootstrap'

local is_vscode = vim.g.vscode ~= nil

vim.g.base16_colorspace = 256
vim.g.base16_background_transparent = 1

if not is_vscode then
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
else
  -- still a WIP, review which plugins setup
  local vscode = require 'vscode'

  local function map(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, function()
      vscode.call(rhs)
    end, { silent = true, noremap = true })
  end

  -- Remap folding keys
  map('n', 'zM', 'editor.foldAll')
  map('n', 'zR', 'editor.unfoldAll')
  map('n', 'zc', 'editor.fold')
  map('n', 'zC', 'editor.foldRecursively')
  map('n', 'zo', 'editor.unfold')
  map('n', 'zO', 'editor.unfoldRecursively')
  map('n', 'za', 'editor.toggleFold')
end

-- Update `runtimepath` with treesitter parsers configured by nix config
-- It has to be located here because `lazy` overrides `runtimepath`
local treesitter_parsers = vim.fn.stdpath 'data' .. '/treesitter-parsers'
vim.opt.runtimepath:append(treesitter_parsers)

vim.filetype.add {
  pattern = {
    ['.*/hypr/.*%.conf'] = 'hyprlang',
  },
}
