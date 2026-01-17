return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    branch = 'main',
    lazy = false,
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          if vim.treesitter.language.get_lang(vim.bo.filetype) then
            pcall(vim.treesitter.start)
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter', branch = 'main' },
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      }

      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'

      vim.keymap.set({ 'x', 'o' }, 'af', function()
        select.select_textobject('@function.outer', 'textobjects')
      end, { desc = 'Select [A]round [F]unction' })
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        select.select_textobject('@function.inner', 'textobjects')
      end, { desc = 'Select [I]nside [F]unction' })

      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        select.select_textobject('@class.outer', 'textobjects')
      end, { desc = 'Select [A]round [C]lass' })
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        select.select_textobject('@class.inner', 'textobjects')
      end, { desc = 'Select [I]nside [C]lass' })

      vim.keymap.set({ 'x', 'o' }, 'ap', function()
        select.select_textobject('@parameter.outer', 'textobjects')
      end, { desc = 'Select [A]round [P]arameter' })
      vim.keymap.set({ 'x', 'o' }, 'ip', function()
        select.select_textobject('@parameter.inner', 'textobjects')
      end, { desc = 'Select [I]nside [P]arameter' })

      vim.keymap.set({ 'x', 'o' }, 'al', function()
        select.select_textobject('@loop.outer', 'textobjects')
      end, { desc = 'Select [A]round [L]oop' })
      vim.keymap.set({ 'x', 'o' }, 'il', function()
        select.select_textobject('@loop.inner', 'textobjects')
      end, { desc = 'Select [I]nside [L]oop' })

      vim.keymap.set({ 'x', 'o' }, 'ii', function()
        select.select_textobject('@conditional.outer', 'textobjects')
      end, { desc = 'Select [A]round [I]f conditional' })
      vim.keymap.set({ 'x', 'o' }, 'ai', function()
        select.select_textobject('@conditional.inner', 'textobjects')
      end, { desc = 'Select [I]nside [I]f conditional' })

      vim.keymap.set({ 'x', 'o' }, 'as', function()
        select.select_textobject('@local.scope', 'locals')
      end, { desc = 'Select [A]round [S]cope' })

      vim.keymap.set({ 'x', 'o' }, 'ab', function()
        select.select_textobject('@block.outer', 'textobjects')
      end, { desc = 'Select [A]round [B]lock' })
      vim.keymap.set({ 'x', 'o' }, 'ib', function()
        select.select_textobject('@block.inner', 'textobjects')
      end, { desc = 'Select [I]nside [B]block' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
        move.goto_next_start('@function.outer', 'textobjects')
      end, { desc = 'Next [F]unction start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']c', function()
        move.goto_next_start('@class.outer', 'textobjects')
      end, { desc = 'Next [C]lass start' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
        move.goto_next_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
      end, { desc = 'Next l[O]op start' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
        move.goto_next_start('@local.scope', 'locals')
      end, { desc = 'Next [S]cope start' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
        move.goto_next_start('@fold', 'folds')
      end, { desc = 'Next fold start' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
        move.goto_next_end('@function.outer', 'textobjects')
      end, { desc = 'Next function end ([M])' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']C', function()
        move.goto_next_end('@class.outer', 'textobjects')
      end, { desc = 'Next [C]lass end' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
        move.goto_previous_start('@function.outer', 'textobjects')
      end, { desc = 'Previous [F]unction start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[c', function()
        move.goto_previous_start('@class.outer', 'textobjects')
      end, { desc = 'Previous [C]lass start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[o', function()
        move.goto_previous_start({ '@loop.inner', '@loop.outer' }, 'textobjects')
      end, { desc = 'Previous l[O]op start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[s', function()
        move.goto_previous_start('@local.scope', 'locals')
      end, { desc = 'Previous [S]cope start' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[z', function()
        move.goto_previous_start('@fold', 'folds')
      end, { desc = 'Previous fold start' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
        move.goto_previous_end('@function.outer', 'textobjects')
      end, { desc = 'Previous function end ([M])' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[C', function()
        move.goto_previous_end('@class.outer', 'textobjects')
      end, { desc = 'Previous [C]lass end' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']d', function()
        move.goto_next('@conditional.outer', 'textobjects')
      end, { desc = 'Next con[D]itional' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[d', function()
        move.goto_previous('@conditional.outer', 'textobjects')
      end, { desc = 'Previous con[D]itional' })
    end,
  },
}
