{ pkgs, ... }: {
  programs.nixvim = {
    plugins = {
      fugitive.enable = true;
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          signs = {
            add = { hl = "GitSignsAdd"; text = "│"; numhl = "GitSignsAddNr"; linehl = "GitSignsAddLn"; };
            change = { hl = "GitSignsChange"; text = "│"; numhl = "GitSignsChangeNr"; linehl = "GitSignsChangeLn"; };
            delete = { hl = "GitSignsDelete"; text = "_"; numhl = "GitSignsDeleteNr"; linehl = "GitSignsDeleteLn"; };
            topdelete = { hl = "GitSignsDelete"; text = "‾"; numhl = "GitSignsDeleteNr"; linehl = "GitSignsDeleteLn"; };
            changedelete = { hl = "GitSignsChange"; text = "~"; numhl = "GitSignsChangeNr"; linehl = "GitSignsChangeLn"; };
          };
        };
      };
    };

    keymaps = [
      {
        key = "<leader>a";
        action = "<cmd>Git blame<cr>";
        mode = "n";
        options = {
          noremap = true;
          silent = true;
        };
      }
    ];

    extraPlugins = with pkgs.vimPlugins; [
      vim-rhubarb
    ];
  };
}
