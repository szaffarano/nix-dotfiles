{ config, lib, ... }: {
  programs.nixvim = {

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = lib.mapAttrsToList
      (key: config: {
        mode = config.mode or "";
        key = key;
        action = if builtins.isString config then config else config.action;
        options = {
          silent = true;
        } // {
          desc =
            if builtins.isString config then
              config
            else
              (config.desc or config.action);
        } // (if builtins.isString config then
          { }
        else
          (removeAttrs config [ "mode" "action" ]));
      })
      {
        "<Space>" = "<NOP>";

        # Esc to clear search results
        "<esc>" = {
          action = ":noh<CR>";
          mode = "n";
        };

        # fix Y behaviour
        "Y" = {
          action = "y$";
          mode = "n";
        };

        "<C-u>" = {
          mode = "n";
          action = "<C-u>zz";
          desc = "Half-page up";
        };

        "<C-d>" = {
          mode = "n";
          action = "<C-d>zz";
          desc = "Half-page down";
        };

        # move selected line / block of text
        "K" = {
          mode = "v";
          action = ":m '<-2<CR>gv=gv";
          desc = "Move block up";
        };

        "J" = {
          mode = "v";
          action = ":m '>+1<CR>gv=gv";
          desc = "Move block down";
        };

        "p" = {
          action = ''"_dP'';
          mode = "v";
          noremap = true;
          silent = true;
        };

        "<C-x>" = {
          action = "<cmd>bdelete<cr>";
          desc = "Delete buffer";
        };

        # navigate to left/right window
        "<leader>h" = {
          action = "<C-w>h";
          mode = "n";
        };
        "<leader>l" = {
          action = "<C-w>l";
          mode = "n";
        };

        # copy/paste to system clipboard
        "<leader>y" = {
          action = ''"+y'';
          desc = "Copy to OS clipboard";
        };
        "<leader>p" = {
          action = ''"+p'';
          desc = "Paste OS clipboard after";
        };
        "<leader>d" = {
          action = ''"+d'';
          desc = "Delete and copy to OS clipboard";
        };

        # resize with arrows
        "<A-Up>" = {
          action = ":resize -2<CR>";
          mode = "n";
        };
        "<A-Down>" = {
          action = ":resize +2<CR>";
          mode = "n";
        };
        "<A-Left>" = {
          action = ":vertical resize +2<CR>";
          mode = "n";
        };
        "<A-Right>" = {
          action = ":vertical resize -2<CR>";
          mode = "n";
        };

        # move current line up/down
        # M = Alt key
        "<M-k>" = {
          action = ":move-2<CR>";
          mode = "n";
        };
        "<M-j>" = {
          action = ":move+<CR>";
          mode = "n";
        };

        "<leader>rp" = {
          action = ":!remi push<CR>";
          mode = "n";
        };

        "<F12>" = {
          action = "<Cmd>set spell!<cr>";
          desc = "Toggle spelling";
        };

        # move between windows
        "<C-h>" = {
          action = "<C-w>h";
          mode = "n";
        };
        "<C-j>" = {
          action = "<C-w>j";
          mode = "n";
        };
        "<C-k>" = {
          action = "<C-w>k";
          mode = "n";
        };
        "<C-l>" = {
          action = "<C-w>l";
          mode = "n";
        };

        "<A-h>" = {
          action = ":vertical resize +2<CR>";
          mode = "n";
        };
        "<A-l>" = {
          action = ":vertical resize -2<CR>";
          mode = "n";
        };
        "<A-j>" = {
          action = ":resize -2<CR>";
          mode = "n";
        };
        "<A-k>" = {
          action = ":resize +2<CR>";
          mode = "n";
        };

        # move between tabs and buffers
        "<C-Left>" = {
          action = "<Cmd>tabprev<CR> <Cmd>redraw!<CR>";
          mode = "n";
          silent = true;
          noremap = true;
        };
        "<C-Right>" = {
          action = "<Cmd>tabnext<CR> <Cmd>redraw!<CR>";
          mode = "n";
          silent = true;
          noremap = true;
        };
        "<Left>" = {
          action = "<Cmd>bp<CR> <Cmd>redraw!<CR>";
          mode = "n";
          silent = true;
          noremap = true;
        };
        "<Right>" = {
          action = "<Cmd>bn<CR> <Cmd>redraw!<CR>";
          mode = "n";
          silent = true;
          noremap = true;
        };

        # better indenting
        ">" = {
          action = ">gv";
          mode = "v";
        };
        "<" = {
          action = "<gv";
          mode = "v";
        };
        "<TAB>" = {
          action = ">gv";
          mode = "v";
        };
        "<S-TAB>" = {
          action = "<gv";
          mode = "v";
        };
      };
  };
}
