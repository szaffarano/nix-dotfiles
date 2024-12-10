local org_base_path = '~/Documents/org.new'

return {
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    dependencies = { 'nvim-orgmode/org-bullets.nvim', 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('orgmode').setup {
        org_agenda_files = org_base_path .. '/**/*',

        org_id_link_to_org_use_id = true,

        org_default_notes_file = org_base_path .. '/captures/refile.org',
        org_log_into_drawer = 'LOGBOOK',
        org_tags_column = -100,

        org_deadline_warning_days = 7,

        org_todo_keywords = { 'TODO(t)', 'PROGRESS(p)', '|', 'DONE(d)', 'REJECTED(r)' },

        win_border = 'single',
        win_split_mode = 'auto',

        mappings = {
          org = {
            org_timestamp_up = '<A-k>',
            org_timestamp_down = '<A-j>',
          },
        },

        org_capture_templates = {
          r = {
            description = 'Refile',
            template = '* TODO %?  :triage: \n  SCHEDULED: %T',
          },
          t = {
            description = 'Todo',
            template = '* TODO %? :triage:personal:\n  SCHEDULED: %T',
            target = org_base_path .. '/captures/todos.org',
            headline = 'Inbox',
            datetree = {
              tree_type = 'week',
              reversed = true,
            },
          },
          w = {
            description = 'Work todo',
            template = '* TODO %?  :triage:work: \n  SCHEDULED: %T',
            target = org_base_path .. '/captures/work.org',
            headline = 'Inbox',
            datetree = {
              tree_type = 'week',
              reversed = true,
            },
          },
          j = {
            description = 'Journal',
            template = '\n*** %U\n    %?',
            target = org_base_path .. '/captures/journal.org',
            datetree = {
              tree_type = 'week',
              reversed = true,
            },
          },
          d = {
            description = 'Daily',
            template = '* Daily %U  :note: \n  %?',
            target = org_base_path .. '/daily.org',
            datetree = {
              tree_type = 'week',
              reversed = true,
            },
          },
        },
      }
      require('org-bullets').setup {
        concealcursor = false,
      }
      vim.api.nvim_create_user_command('Agenda', function()
        local current_buffer = vim.api.nvim_get_current_buf()
        require('orgmode').agenda:agenda()
        vim.api.nvim_buf_delete(current_buffer, { force = true })
      end, {})
    end,
  },
  {
    'nvim-orgmode/orgmode',
  },
  {
    'chipsenkbeil/org-roam.nvim',
    dependencies = {
      {
        'nvim-orgmode/orgmode',
      },
    },
    config = function()
      require('org-roam').setup {
        directory = org_base_path .. '/roam',
        org_files = {
          org_base_path,
        },
      }
    end,
  },
}
