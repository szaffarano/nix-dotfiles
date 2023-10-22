-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local ok, telescope = pcall(require, 'telescope')
if not ok then
  return
end

local utils = require 'sebas.utils.ts'
local ts_builtin = require 'telescope.builtin'

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(telescope.load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', ts_builtin.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', ts_builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sf', ts_builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', ts_builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', ts_builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', ts_builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', ts_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>/', utils.find_buffer, { desc = '[/] Fuzzily search in current buffer]' })
vim.keymap.set('n', '<leader>fd', utils.files_dotfiles, { desc = '[F]ind files in the [D]otfiles dir' })
vim.keymap.set('n', '<leader>wf', utils.files_wiki, { desc = '[W]iki [F]ind' })
vim.keymap.set('n', '<leader>wg', utils.grep_wiki, { desc = '[W]iki [G]rep' })
