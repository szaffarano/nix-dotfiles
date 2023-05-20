local ok, orgmode, ts_configs, obullets
ok, orgmode = pcall(require, 'orgmode')
if not ok then
  print 'orgmode plugin is not installed'
  return
end

ok, ts_configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  print 'nvim-treesitter.configs is not installed'
  return
end

ok, obullets = pcall(require, 'org-bullets')
if not ok then
  print 'org-bullets.nvim plugin is not installed'
  return
end

vim.api.nvim_create_autocmd('FileType', { pattern = 'org', command = [[setlocal nofoldenable]] })

orgmode.setup_ts_grammar()

ts_configs.setup {
  ensure_installed = { 'org' },
}

orgmode.setup {
  -- TODO: move to an external config since it's used also by wiki.vim
  org_agenda_files = { '~/Documents/org/**/*' },
  org_default_notes_file = '~/Documents/org/refile.org',
  win_split_mode = 'float',
  win_border = 'single',
  org_capture_templates = {
    j = {
      description = 'Journal',
      template = '\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?',
      target = '~/Documents/org/journal.org',
    },
    e = 'Event',
    er = {
      description = 'recurring',
      template = '** %?\n %T',
      target = '~/Documents/org/calendar.org',
      headline = 'recurring',
    },
    eo = {
      description = 'one-time',
      template = '** %?\n %T',
      target = '~/Documents/org/calendar.org',
      headline = 'one-time',
    },
  },
}

obullets.setup()
