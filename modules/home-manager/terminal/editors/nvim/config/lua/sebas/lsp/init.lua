vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      if vim.fn.maparg(keys, 'n') == '' then
        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end
    end

    --  To jump back, press <C-t>.
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('<S-F6>', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration') --  For example, in C this would take you to the header.

    -- Highlight references of the word under your cursor when your cursor
    -- rests there for a little while.
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

local servers = {
  'bashls',
  'clangd',
  'gopls',
  'grammarly',
  'jsonls',
  'ltex',
  'lua_ls',
  'nil_ls',
  'ocamllsp',
  'pyright',
  'terraformls',
  'tsserver', -- TODO: https://github.com/pmizio/typescript-tools.nvim
  'yamlls',
}

local lspconfig = require 'lspconfig'
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
for _, server_name in ipairs(servers) do
  local ok, server = pcall(require, 'sebas.lsp.servers.' .. server_name)
  if not ok then
    server = {}
  end
  server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  lspconfig[server_name].setup(server)
end
