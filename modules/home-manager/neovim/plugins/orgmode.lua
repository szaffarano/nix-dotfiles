local org_path = function(path)
  local org_directory = '~/Documents/org'
  local pattern = path or '**/*'
  return ('%s/%s'):format(org_directory, pattern)
end

require('orgmode').setup {
  org_agenda_files = { org_path() },
  org_default_notes_file = org_path 'refile.org',
  org_hide_emphasis_markers = true,
  org_agenda_text_search_extra_files = { 'agenda-archives' },
  org_agenda_start_on_weekday = false,
  org_todo_keywords = { 'TODO(t)', 'PROGRESS(p)', '|', 'DONE(d)', 'REJECTED(r)' },
  win_split_mode = 'float',
  win_border = 'single',
  mappings = {
    org = {
      org_timestamp_up = '<A-k>',
      org_timestamp_down = '<A-j>',
    },
  },
  org_capture_templates = {
    t = {
      description = 'Refile',
      template = '* TODO %?  :triage: \n  SCHEDULED: %T',
    },
    T = {
      description = 'Todo',
      template = '* TODO %? :personal:\n  SCHEDULED: %T',
      target = org_path 'todos.org',
      headline = 'Inbox',
    },
    w = {
      description = 'Work todo',
      template = '* TODO %?  :work: \n  SCHEDULED: %T',
      target = org_path 'work.org',
      headline = 'Inbox',
    },
    d = {
      description = 'Daily',
      template = '* Daily %U  :note: \n  %?',
      target = org_path 'daily.org',
    },
  },
}
