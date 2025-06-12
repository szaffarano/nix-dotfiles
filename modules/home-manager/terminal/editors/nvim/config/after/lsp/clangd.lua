return {
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },

  cmd = {
    'clangd',
    '-j=10',
    '--background-index',
    '--background-index-priority=background',
    '--clang-tidy',
    '--completion-style=detailed',
    '--function-arg-placeholders',
    '--header-insertion=never',
    '--log=error',
    '--malloc-trim',
    '--pch-storage=memory',
    '--fallback-style=webkit',
    '--offset-encoding=utf-16',
  },
}
