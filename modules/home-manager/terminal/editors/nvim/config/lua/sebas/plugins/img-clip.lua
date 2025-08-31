return {
  'HakonHarnes/img-clip.nvim',
  event = 'VeryLazy',
  opts = {
    default = {
      embed_image_as_base64 = false,
      prompt_for_file_name = true,
      drag_and_drop = {
        insert_mode = false,
      },
      use_absolute_path = false,
      relative_to_current_file = true,
      show_dir_path_in_prompt = true,
      dir_path = function()
        local filename = vim.api.nvim_buf_get_name(0)
        if filename == '' then
          return './assets'
        end
        local name = vim.fn.fnamemodify(filename, ':t:r')
        return './' .. name
      end,
    },
    filetypes = {
      org = {
        template = [=[
[[file:./$FILE_PATH]]
#+CAPTION: $CURSOR
#+NAME: fig:$LABEL
    ]=], ---@type string | fun(context: table): string
      },
    },
  },
  keys = {
    { '<leader>ip', '<cmd>PasteImage<cr>', desc = '[I]mage [P]aste from system clipboard' },
  },
}
