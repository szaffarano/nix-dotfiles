-- TODO move to another place
vim.filetype.add {
  extension = {
    jinja = 'jinja',
    jinja2 = 'jinja',
    j2 = 'jinja',
  },
}

local servers = {
  'asm_lsp',
  'basedpyright',
  'bashls',
  'clangd',
  'copilot',
  'dockerls',
  'gopls',
  'jinja_lsp',
  'jsonls',
  'ltex_plus',
  'lua_ls',
  'marksman',
  'nil_ls',
  'ruff',
  'taplo',
  'terraformls',
  'ts_ls',
  'yamlls',
  'zls',
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),

  callback = function(event)
    local ts = require 'telescope.builtin'

    local map = function(keys, func, desc)
      if vim.fn.maparg(keys, 'n') == '' then
        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end
    end

    map('gd', ts.lsp_definitions, '[G]oto [D]efinition')
    map('gr', ts.lsp_references, '[G]oto [R]eferences')
    map('gI', ts.lsp_implementations, '[G]oto [I]mplementation')
    map('<leader>D', ts.lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ds', ts.lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', ts.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('<leader>rs', vim.lsp.buf.rename, '[R]ename [S]ymbol')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    map('<leader>k', function()
      local buf = vim.api.nvim_get_current_buf()
      local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = buf }
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
    end, 'Toggle inlay hints')
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

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

    -- if client and client:supports_method 'textDocument/completion' then
    --   vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    -- end
  end,
})

vim.diagnostic.config {
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
      [vim.diagnostic.severity.WARN] = 'WarningMsg',
    },
  },
}

vim.lsp.enable(servers)

-- vim.cmd 'set completeopt+=noselect'
-- vim.o.winborder = 'rounded'
