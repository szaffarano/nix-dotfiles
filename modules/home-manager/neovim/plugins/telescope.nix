{
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      keymaps = {
        "<leader>?" = {
          action = "oldfiles";
          desc = "[?] Find recently opened files";
        };
        "<leader><space>" = {
          action = "buffers";
          desc = "[ ] Find existing buffers";
        };
        "<leader>sf" = {
          action = "find_files";
          desc = "[S]earch [F]iles";
        };
        "<leader>sh" = {
          action = "help_tags";
          desc = "[S]earch [H]elp";
        };
        "<leader>sw" = {
          action = "grep_string";
          desc = "[S]earch current [W]ord";
        };
        "<leader>sg" = {
          action = "live_grep";
          desc = "[S]earch by [G]rep";
        };
        "<leader>sd" = {
          action = "diagnostics";
          desc = "[S]earch [D]iagnostics";
        };
      };

      keymapsSilent = true;

      extensions.fzf-native.enable = true;

      defaults = {
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
        ];
        set_env.COLORTERM = "truecolor";
      };
    };

    files."lua/sebas/utils/telescope.lua".extraConfigLua = builtins.readFile ./telescope.lua;

    # TODO: define keymaps using nixvim API
    extraConfigLua = ''
      vim.keymap.set('n', '<leader>/', require('sebas.utils.telescope').find_buffer, { desc = '[/] Fuzzily search in current buffer]' })
      vim.keymap.set('n', '<leader>fd', require('sebas.utils.telescope').files_dotfiles, { desc = '[F]ind files in the [D]otfiles dir' })
      vim.keymap.set('n', '<leader>wf', require('sebas.utils.telescope').files_wiki, { desc = '[W]iki [F]ind' })
      vim.keymap.set('n', '<leader>wg', require('sebas.utils.telescope').grep_wiki, { desc = '[W]iki [G]rep' })
    '';
  };
}
