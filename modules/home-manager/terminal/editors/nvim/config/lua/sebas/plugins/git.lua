return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      current_line_blame = true,
      update_debounce = 1000,
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            ---@diagnostic disable-next-line: param-type-mismatch
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          ---@diagnostic disable-next-line: param-type-mismatch
          else
            ---@diagnostic disable-next-line: param-type-mismatch
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        map('v', '<leader>ghs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[G]it [h]unk [s]tage' })
        map('v', '<leader>ghr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = '[G]it [h]unk [r]eset' })

        map('n', '<leader>gb', gitsigns.blame, { desc = '[G]it [b]lame' })
        map('n', '<leader>gB', gitsigns.blame_line, { desc = '[G]it [b]lame line' })

        map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = '[G]it [h]unk [s]tage' })
        map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = '[G]it [h]unk [r]eset' })

        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = '[G]it [S]tage buffer' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = '[G]it [R]eset buffer' })

        map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = '[G]it [h]unk [p]review' })
        map('n', '<leader>ghd', gitsigns.diffthis, { desc = '[G]it [h]unk [d]iff against index' })
        map('n', '<leader>ghD', function()
          ---@diagnostic disable-next-line: param-type-mismatch
          gitsigns.diffthis '@'
        end, { desc = '[G]it [h]unk [D]iff against HEAD' })
        map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = '[G]it [t]oggle [b]lame line' })
        map('n', '<leader>gti', gitsigns.preview_hunk_inline, { desc = '[G]it [t]oggle [i]nline preview' })
      end,
    },
  },
}
