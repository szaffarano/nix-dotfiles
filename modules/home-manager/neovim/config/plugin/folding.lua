vim.opt.fillchars = 'fold: '
vim.opt.foldlevel = 99

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldcolumn = 'auto'

vim.o.foldtext = [[
  substitute(getline(v:foldstart), '\\t', repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart) . ' lines)'
]]
