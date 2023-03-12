local ok, lualine, catppuccin
ok, lualine = pcall(require, 'lualine')
if not ok then
  return
end
ok, catppuccin = pcall(require, 'catppuccin')
if not ok then
  return
end

catppuccin.setup {
  flavour = 'frappe',
}

vim.o.termguicolors = true
vim.cmd.colorscheme 'catppuccin'

lualine.setup {
  options = {
    icons_enabled = false,
    theme = 'catppuccin',
    component_separators = '|',
    section_separators = '',
  },
}
