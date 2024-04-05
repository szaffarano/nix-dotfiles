return {
  'barreiroleo/ltex_extra.nvim',
  ft = { 'markdown', 'tex', 'org', 'gitcommit' },
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    require('ltex_extra').setup {
      server_opts = {
        -- on_attach = function(client, bufnr)
        -- print 'Attached!'
        -- end,
        settings = {
          ltex = {
            language = 'en-US',
            diagnosticSeverity = 'information',
            setenceCacheSize = 2000,
            additionalRules = {
              enablePickyRules = true,
              motherTongue = 'en',
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