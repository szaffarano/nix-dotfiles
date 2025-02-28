return {
  'okuuva/auto-save.nvim',
  opts = {
    debug = false,
    write_all_buffers = true,
    debounce_delay = 500,
    noautocmd = false,
    trigger_events = {
      defer_save = { 'FocusLost', 'QuitPre', 'VimSuspend' },
      immediate_save = { 'FocusLost' },
      cancel_deferred_save = { 'InsertEnter' },
    },
  },
  config = function(_, opts)
    require('auto-save').setup(opts)
  end,
}
