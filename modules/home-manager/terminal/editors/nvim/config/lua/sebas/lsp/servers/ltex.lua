local debug = false

local function fileToTable(path)
  local dict = {}
  local f = io.open(path, 'r')
  if not f then
    if debug then
      vim.notify('Could not open file: ' .. path, 'error')
    end
    return dict
  end
  for l in f:lines() do
    table.insert(dict, l)
  end
  if debug then
    vim.notify('Loaded ' .. #dict .. ' lines from ' .. path, 'info')
  end
  return dict
end

return {
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
      dictionary = {
        ['en-US'] = fileToTable(vim.fn.expand '$HOME/Documents/en_US-dictionary.txt'),
      },
      disabledRules = {
        ['en-US'] = fileToTable(vim.fn.expand '$HOME/Documents/en_US-disabled-rules.txt'),
      },
      hiddenFalsePositives = {
        ['en-US'] = fileToTable(vim.fn.expand '$HOME/Documents/en_US-false-positives.txt'),
      },
    },
  },
}
