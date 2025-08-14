local org_base_path = '~/Documents/org.new'
local refile = org_base_path .. '/captures/refile.org'
local utils = require 'sebas.utils.ts'

return {
  {
    'nvim-orgmode/orgmode',
    event = 'VeryLazy',
    ft = { 'org' },
    dependencies = {
      'nvim-orgmode/org-bullets.nvim',
      'nvim-orgmode/telescope-orgmode.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('orgmode').setup {
        org_agenda_files = org_base_path .. '/**/*',

        org_id_link_to_org_use_id = true,

        org_default_notes_file = refile,
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
          f = {
            description = 'Fleeting Note',
            template = '* %?  \nCaptured: %U',
            target = refile,
          },
          l = {
            description = 'Literature Note',
            template = '* %^{Title} :literature:\n:PROPERTIES:\n:SOURCE: %^{Author, Title, Year, Page}\n:END:\n- Summary:\n  %?\n- Key points:\n  - \n- Questions:\n  - ',
            target = refile,
          },
          r = {
            description = 'Refile',
            template = '* TODO %?  :triage: \n  SCHEDULED: %T',
          },
          t = {
            description = 'Todo',
            template = '* TODO %? :triage:personal:\n  SCHEDULED: %T',
            target = org_base_path .. '/captures/todos.org',
            headline = 'Inbox',
            ---@diagnostic disable-next-line: missing-fields
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
            ---@diagnostic disable-next-line: missing-fields
            datetree = {
              tree_type = 'week',
              reversed = true,
            },
          },
          j = {
            description = 'Journal',
            template = '\n*** %U\n    %?',
            target = org_base_path .. '/captures/journal.org',
            ---@diagnostic disable-next-line: missing-fields
            datetree = {
              tree_type = 'week',
              reversed = true,
            },
          },
          d = {
            description = 'Daily',
            template = '* Daily %U  :note: \n  %?',
            target = org_base_path .. '/daily.org',
            ---@diagnostic disable-next-line: missing-fields
            datetree = {
              tree_type = 'week',
              reversed = true,
            },
          },
        },

        org_agenda_custom_commands = {
          z = {
            description = 'Weekly Zettelkasten Triage',
            types = {
              {
                type = 'tags',
                match = 'triage',
                org_agenda_overriding_header = 'Fleeting notes to triage',
                org_agenda_span = 'week',
              },
            },
          },
          c = {
            description = 'Combined view',
            types = {
              {
                type = 'tags_todo',
                match = '+PRIORITY="A"',
                org_agenda_overriding_header = 'High priority todos',
                org_agenda_todo_ignore_deadlines = 'far',
              },
              {
                type = 'agenda',
                org_agenda_overriding_header = 'My daily agenda',
                org_agenda_span = 'day',
              },
              {
                type = 'tags_todo',
                match = 'work',
                org_agenda_overriding_header = 'My work todos',
                org_agenda_todo_ignore_scheduled = 'all',
              },
              {
                type = 'tags_todo',
                match = 'personal',
                org_agenda_overriding_header = 'My personal todos',
                org_agenda_todo_ignore_scheduled = 'all',
              },
              {
                type = 'agenda',
                org_agenda_overriding_header = 'Whole week overview',
                org_agenda_span = 'week',
                org_agenda_start_on_weekday = 1,
                org_agenda_remove_tags = true,
              },
            },
          },
        },
      }
      ---@diagnostic disable-next-line: missing-fields
      require('org-bullets').setup {
        concealcursor = false,
      }

      local telescope_installed, telescope = pcall(require, 'telescope')
      if telescope_installed then
        telescope.load_extension 'orgmode'

        vim.keymap.set('n', '<leader>off', utils.find_files_orgmode, { desc = '[O]orgMode [F]ind [F]iles' })
        vim.keymap.set('n', '<leader>ofh', telescope.extensions.orgmode.search_headings, { desc = '[O]rgMode [F]ind [H]eadings' })
        vim.keymap.set('n', '<leader>ofp', function()
          telescope.extensions.orgmode.search_headings { mode = 'orgfiles' }
        end, { desc = '[O]rgMode [F]ind [P]ages' })
        vim.keymap.set('n', '<leader>og', utils.live_grep_orgmode, { desc = '[O]ogMode [G]rep' })
        vim.keymap.set('n', '<leader>ohr', telescope.extensions.orgmode.refile_heading, { desc = '[O]rgMode [R]efile Heading' })
        vim.keymap.set('n', '<leader>oil', telescope.extensions.orgmode.insert_link, { desc = '[O]rgMode [I]nsert [L]ink' })
      end
      vim.api.nvim_create_user_command('Agenda', function()
        local current_buffer = vim.api.nvim_get_current_buf()
        local agenda_promise = Org.agenda.a()
        if agenda_promise ~= nil then
          agenda_promise:finally(function()
            vim.api.nvim_buf_delete(current_buffer, { force = true })
          end)
        end
      end, {})
    end,
  },
  {
    'chipsenkbeil/org-roam.nvim',
    config = function()
      require('org-roam').setup {
        directory = org_base_path .. '/roam',
        org_roam_autogenerate_ids = true,
        org_files = {
          org_base_path,
        },
      }
    end,
  },
}
