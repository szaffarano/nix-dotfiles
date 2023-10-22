local M = {}

local builtin = require 'telescope.builtin'
local themes = require 'telescope.themes'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

-- TODO parameterize
local wiki_root = '~/Documents/org'

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
function M.files_wiki()
  builtin.find_files {
    prompt_title = 'Wiki files',
    cwd = wiki_root,
    path_display = function(_, path)
      local name = path:match '(.+)%.[^.]+$'
      return name or path
    end,
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace_if(function()
        return action_state.get_selected_entry() == nil
      end, function()
        actions.close(prompt_bufnr)

        local new_name = action_state.get_current_line()
        if new_name == nil or new_name == '' then
          return
        end

        vim.fn['wiki#page#open'](new_name)
      end)

      return true
    end,
  }
end

function M.grep_wiki()
  builtin.live_grep {
    prompt_title = 'Grep Wiki pages',
    cwd = wiki_root,
    search_dirs = { wiki_root },
  }
end

return M
