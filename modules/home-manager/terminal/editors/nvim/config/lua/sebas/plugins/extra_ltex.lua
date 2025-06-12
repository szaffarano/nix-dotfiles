return {
  'barreiroleo/ltex_extra.nvim',
  ft = { 'gitcommit', 'markdown', 'org', 'pandoc', 'plaintex', 'rmd', 'rst', 'tex', 'mdx', 'markdown', 'md' },
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    require('ltex_extra').setup {
      server_opts = {
        settings = {
          ltex = {
            language = 'en-US',
            diagnosticSeverity = 'information',
            setenceCacheSize = 2000,
            additionalRules = {
              enablePickyRules = true,
              motherTongue = 'es-AR',
              languageModel = '~/Documents/n-grams',
            },
          },
        },
      },
      -- store extra dictionary words, ignored FP and disabled rules in a global location
      path = vim.fn.expand '$HOME/Documents/dict',
      log_level = 'info',
    }
  end,
}
