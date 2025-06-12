return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'it', 'describe', 'before_each', 'after_each', 'LOG', 'P' },
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
