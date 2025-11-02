local ltex_utils = require 'sebas.utils.ltex'

return {
  filetypes = ltex_utils.filetypes,
  settings = {
    ltex = {
      language = { 'en-US', 'es-AR' },
      checkFrequency = 'save',
      diagnosticSeverity = 'information',
      setenceCacheSize = 2000,
      additionalRules = {
        enablePickyRules = true,
        motherTongue = 'es-AR',
        languageModel = '~/Documents/n-grams',
      },
    },
  },
}
