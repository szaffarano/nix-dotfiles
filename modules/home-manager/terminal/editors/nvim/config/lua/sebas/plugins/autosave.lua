return {
  'okuuva/auto-save.nvim',
  config = function()
    require('auto-save').setup {
      trigger_events = {
        immediate_save = {},
        defer_save = { 'FocusLost' },
        cancel_deferred_save = {},
      },
      write_all_buffers = true,
      debounce_delay = 500,
      noautocmd = true,
    }
  end,
}
