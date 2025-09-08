-- Taken from https://github.com/MariaSolOs/dotfiles/blob/main/.config/nvim/lsp/taplo.lua
---@type vim.lsp.Config
return {
  settings = {
    taplo = {
      configFile = { enabled = true },
      schema = {
        enabled = true,
        catalogs = { 'https://www.schemastore.org/api/json/catalog.json' },
        cache = {
          memoryExpiration = 60,
          diskExpiration = 600,
        },
      },
    },
  },
}
