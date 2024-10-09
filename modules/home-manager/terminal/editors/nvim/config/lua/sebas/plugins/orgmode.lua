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
        org_agenda_skip_deadline_if_done = false,
        org_agenda_skip_scheduled_if_done = false,

        org_id_link_to_org_use_id = true,

        org_default_notes_file = org_base_path .. '/refile.org',
        org_log_into_drawer = 'LOGBOOK',
        org_tags_column = 100,

        org_deadline_warning_days = 60,

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
            target = org_base_path .. '/todos.org',
            headline = 'Inbox',
            datetree = {
              tree_type = 'week',
              reversed = true,
            },
          },
          w = {
            description = 'Work todo',
            template = '* TODO %?  :triage:work: \n  SCHEDULED: %T',
            target = org_base_path .. '/work.org',
            headline = 'Inbox',
            datetree = {
              tree_type = 'week',
              reversed = true,
            },
          },
          j = {
            description = 'Journal',
            template = '\n*** %U\n    %?',
            target = org_base_path .. '/journal.org',
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
        concealcursor = true,
      }
    end,
  },
  {
    'nvim-orgmode/orgmode',
  },
}
