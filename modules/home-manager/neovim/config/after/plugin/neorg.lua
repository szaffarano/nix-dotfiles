local ok, neorg = pcall(require, 'neorg')
if not ok then
  print 'neorg plugin is not installed'
  return
end

neorg.setup {
  load = {
    ['core.defaults'] = {},
    ['core.summary'] = {},
    ['core.qol.toc'] = {
      config = {
        close_after_use = true,
      },
    },
    ['core.completion'] = {
      config = {
        engine = 'nvim-cmp',
      },
    },
    ['core.concealer'] = {
      config = {
        icon_preset = 'diamond',
        icons = {
          todo = {
            done = {
              icon = '󰸞',
            },
            pending = {
              icon = '󰦕',
            },
          },
        },
      },
    },
    ['core.journal'] = {
      config = {
        toc_format = function(entries)
          local months_text = {
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
          }
          local output = {}

          local current_year
          local current_month
          for _, entry in ipairs(entries) do
            local yy = entry[1]
            local mm = entry[2]
            local link = entry[4]
            local title = entry[5]

            if not current_year or current_year < yy then
              current_year = yy
              table.insert(output, string.format('* %s', current_year))
            end
            if not current_month or current_month < mm then
              current_month = mm
              table.insert(output, string.format(' ** %s', months_text[current_month]))
            end

            table.insert(output, string.format('  - %s[%s]', link, title))
          end

          return output
        end,
      },
    },
    ['core.dirman'] = {
      config = {
        workspaces = {
          notes = '~/Documents/notes',
        },
        default_workspace = 'notes',
      },
    },
  },
}

vim.keymap.set('n', '<leader>ni', '<Cmd>Neorg index<CR>', { desc = 'Go to Neorg index in the default workspace' })

vim.keymap.set('n', '<leader>njy', '<Cmd>Neorg journal yesterday<CR>', { desc = [[Go to Neorg today' journal]] })
vim.keymap.set('n', '<leader>njj', '<Cmd>Neorg journal today<CR>', { desc = [[Go to Neorg today' journal]] })
vim.keymap.set('n', '<leader>njt', '<Cmd>Neorg journal tomorrow<CR>', { desc = [[Go to Neorg today' journal]] })
vim.keymap.set('n', '<localleader>ji', '<Cmd>Neorg journal toc update<CR>', { desc = [[Update Neorg journal TOC]] })
vim.keymap.set('n', '<localleader>im', '<Cmd>Neorg inject-metadata<CR>', { desc = 'Inject Neorg metadata' })
vim.keymap.set('n', '<localleader>um', '<Cmd>Neorg update-metadata<CR>', { desc = 'Update Neorg metadata' })

vim.keymap.set('n', '<leader>nq', '<Cmd>Neorg return<CR>', { desc = 'Exit neorg' })
