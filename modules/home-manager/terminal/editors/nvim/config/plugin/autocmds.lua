-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank {
      higroup = 'Visual',
      timeout = 100,
    }
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
    'mdx',
    'org',
  },
  command = 'setlocal spell spelllang=en,es,de,sv',
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

-- Autosave
local group = vim.api.nvim_create_augroup('autosave', {})

vim.api.nvim_create_autocmd('User', {
  pattern = 'AutoSaveWritePost',
  group = group,

  callback = function(opts)
    if opts.data.saved_buffer ~= nil then
      local filename = vim.api.nvim_buf_get_name(opts.data.saved_buffer)
      local max_levels = 3
      filename = table.concat(vim.split(filename, '/'), '/', math.max(#vim.split(filename, '/') - max_levels + 1, 1))
      vim.notify('AutoSave: saved ' .. filename .. ' at ' .. vim.fn.strftime '%H:%M:%S', vim.log.levels.INFO)
    end
  end,
})
