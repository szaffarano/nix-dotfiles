return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        bash = { 'bash' },
        dockerfile = { 'hadolint' },
        fish = { 'fish' },
        go = { 'golangcilint' },
        markdown = { 'markdownlint' },
        nix = { 'nix' },
        sh = { 'shellcheck' },
        zsh = { 'zsh' },
      }

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function(event)
          require('lint').try_lint()
          local function toggle_diagnostic()
            vim.diagnostic.enable(not vim.diagnostic.is_enabled())
          end
          vim.keymap.set({ 'n', 'v' }, '<F2>', toggle_diagnostic, { buffer = event.buf, desc = 'Toggle diagnostic' })
        end,
      })

      vim.api.nvim_create_autocmd('BufEnter', {
        desc = 'Ignore linting in .env files',
        group = lint_augroup,
        pattern = {
          '.env',
          '.envrc',
        },
        callback = function(args)
          print('about to disable linting for ' .. args.buf)
          vim.diagnostic.enable(false, { buf = args.buf })
        end,
      })
    end,
  },
}
