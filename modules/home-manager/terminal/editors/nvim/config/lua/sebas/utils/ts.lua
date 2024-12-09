local M = {}

local builtin = require 'telescope.builtin'
local themes = require 'telescope.themes'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

-- TODO parameterize
local wiki_root = '~/Documents/org.new'

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

-- Thanks https://github.com/lervag/dotnvim/
function M.find_files_orgmode()
  builtin.find_files {
    prompt_title = 'Wiki files',
    file_ignore_patterns = { '^%.git/' },
    cwd = wiki_root,
    path_display = function(_, path)
      local name = path:match '(.+)%.[^.]+$'
      return name or path
    end,
  }
end

function M.live_grep_orgmode()
  builtin.live_grep {
    prompt_title = 'Grep Wiki pages',
    cwd = wiki_root,
    search_dirs = { wiki_root },
  }
end

return M
