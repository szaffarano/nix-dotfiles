return {
  'okuuva/auto-save.nvim',
  event = { 'FocusLost' },
  opts = {
    write_all_buffers = true,
    debounce_delay = 500,
    noautocmd = true,
    trigger_events = {
      immediate_save = { 'FocusLost' },
      defer_save = {},
      cancel_deferred_save = {},
    },
  },
  config = {
    group = vim.api.nvim_create_augroup('autosave', {}),

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
    }),
  },
}
