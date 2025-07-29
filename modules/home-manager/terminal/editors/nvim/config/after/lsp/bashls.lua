return {
  cmd = {
    'mise',
    'exec',
    'node@latest',
    '--',
    'bash-language-server',
    'start',
  },
  settings = {
    filetypes = { 'sh', 'zsh', 'bash' },
  },
}
