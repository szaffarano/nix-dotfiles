-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Enable spellcheck for some filetypes
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable spelcheck on some file types',
  group = vim.api.nvim_create_augroup('enable-spell-check', { clear = true }),
  pattern = {
    'tex',
    'latex',
    'markdown',
    'org',
  },
  command = 'setlocal spell spelllang=en,es',
})

-- Orgmode
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'org',
  callback = function()
    vim.keymap.set('i', '<A-CR>', '<cmd>lua require("orgmode").action("org_mappings.meta_return")<CR>', {
      buffer = true,
    })
  end,
})
