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
  -- 'ltex_plus',
  'lua_ls',
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

    Snacks.keymap.set('n', 'gd', ts.lsp_definitions, { desc = 'LSP: [G]oto [D]efinition' })
    Snacks.keymap.set('n', 'gr', ts.lsp_references, { desc = 'LSP: [G]oto [R]eferences' })
    Snacks.keymap.set('n', 'gI', ts.lsp_implementations, { desc = 'LSP: [G]oto [I]mplementation' })
    Snacks.keymap.set('n', '<leader>D', ts.lsp_type_definitions, { desc = 'LSP: Type [D]efinition' })
    Snacks.keymap.set('n', '<leader>ds', ts.lsp_document_symbols, { desc = 'LSP: [D]ocument [S]ymbols' })
    Snacks.keymap.set('n', '<leader>ws', ts.lsp_dynamic_workspace_symbols, { desc = 'LSP: [W]orkspace [S]ymbols' })
    Snacks.keymap.set('n', '<leader>rs', vim.lsp.buf.rename, { desc = 'LSP: [R]ename [S]ymbol' })
    Snacks.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP: [C]ode [A]ction' })
    Snacks.keymap.set('n', '<leader>k', function()
      local buf = vim.api.nvim_get_current_buf()
      local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = buf }
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
    end, { desc = 'LSP: Toggle inlay hints' })
    Snacks.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP: Hover Documentation' })
    Snacks.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP: [G]oto [D]eclaration' })

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
