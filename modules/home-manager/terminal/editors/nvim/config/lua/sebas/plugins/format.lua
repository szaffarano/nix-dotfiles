return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<C-M-l>',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      asm = { 'nasmfmt' },
      bash = { 'shfmt' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      kdl = { 'kdlfmt' },
      lua = { 'stylua' },
      nix = { 'alejandra' },
      python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      terraform = { 'terraform_fmt' },
      markdown = { 'rumdl' },
      toml = { 'taplo' },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      yml = { 'yq' },
      zsh = { 'shfmt' },
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    formatters = {
      rumdl = {
        command = 'rumdl',
        args = { 'fmt', '-', '--quiet' },
        stdin = true,
      },
      nasmfmt = {
        command = 'nasmfmt',
        args = { '$FILENAME' },
        stdin = false,
      },
      shfmt = {
        prepend_args = { '-i', '2' },
      },
    },
  },
  init = function()
    vim.o.formatexpr = 'v:lua.require"conform".formatexpr()'

    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = 'Disable autoformat-on-save',
      bang = true,
    })

    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = 'Re-enable autoformat-on-save',
    })
  end,
}
