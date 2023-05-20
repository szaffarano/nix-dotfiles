local M = {}

local builtin = require 'telescope.builtin'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

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
    cwd = '~/Documents/org',
    disable_devicons = true,
    find_command = { 'rg', '--files', '--sort', 'path' },
    file_ignore_patterns = {
      '%.stversions/',
      '%.git/',
    },
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

return M
