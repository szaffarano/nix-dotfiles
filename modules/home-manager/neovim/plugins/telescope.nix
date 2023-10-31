{ lib, config, ... }:
let lspEnabled = config.programs.nixvim.plugins.lsp.enable;
in {
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
      } // (lib.optionalAttrs lspEnabled {
        "<leader>sr" = {
          action = "lsp_references";
          desc = "[S]search [R]eferences";
        };
        "<leader>si" = {
          action = "lsp_implementations";
          desc = "[S]search [I]mplementations";
        };
        "<leader>std" = {
          action = "lsp_type_definitions";
          desc = "[S]search [T]ype [D]definitions";
        };
        "<leader>sws" = {
          action = "lsp_workspace_symbols";
          desc = "[S]search [W]orkspace [S]ymbols";
        };
        "<leader>ss" = {
          action = "lsp_document_symbols";
          desc = "[S]search document [S]ymbols";
        };
      });

      keymapsSilent = true;

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

      extensions = {
        fzf-native.enable = true;
        file_browser = {
          enable = true;
          hidden = true;
        };
      };
    };

    files."lua/sebas/utils/telescope.lua".extraConfigLua =
      builtins.readFile ./telescope.lua;

    keymaps = [
      {
        key = "<leader>bf";
        action = "<cmd>Telescope file_browser<cr>";
        options = { desc = "[B]rowse [F]iles"; };
      }
      {
        key = "<leader>/";
        lua = true;
        action = "require('sebas.utils.telescope').find_buffer";
        options = { desc = "[/] Fuzzily search in current buffer]"; };
      }
      {
        key = "<leader>fd";
        lua = true;
        action = "require('sebas.utils.telescope').files_dotfiles";
        options = { desc = "[F]ind files in the [D]otfiles dir"; };
      }
      {
        key = "<leader>wf";
        lua = true;
        action = "require('sebas.utils.telescope').files_wiki";
        options = { desc = "[W]iki [F]ind"; };
      }
      {
        key = "<leader>wg";
        lua = true;
        action = "require('sebas.utils.telescope').grep_wiki";
        options = { desc = "[W]iki [G]rep"; };
      }
    ];
  };
}
