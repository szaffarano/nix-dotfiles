return {
  settings = {
    Lua = {
      diagnostics = {
        globals = {
          'after_each',
          'before_each',
          'describe',
          'it',
          'LOG',
          'Org',
          'P',
          'Snacks',
          'vim',
        },
      },
      completion = {
        keywordSnippet = 'Replace',
        callSnippet = 'Replace',
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
