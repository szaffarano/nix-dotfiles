local M = {}

local builtin = require 'telescope.builtin'
local themes = require 'telescope.themes'

function M.find_buffer()
  builtin.current_buffer_fuzzy_find(themes.get_dropdown {
    winblend = 10,
    previewer = false,
  })
end

function M.files_dotfiles()
  builtin.git_files {
    prompt_title = 'Find Files: ~/.dotfiles',
    cwd = '~/.dotfiles',
  }
end

return M
