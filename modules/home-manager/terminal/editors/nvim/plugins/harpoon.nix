{ pkgs, ... }:
let
  org-bullets-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "org-bullets.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-orgmode";
      repo = "org-bullets.nvim";
      rev = "208b8519bccbb9b67deee7115fd6587983d279c1";
      sha256 = "sha256-LEI+d9KKnm7ctOBLn3yDHVgoYHd9QrCyd+BXqpj2W98=";
    };
  };
in
{
  programs.nixvim = {
    extraConfigLua = builtins.readFile ./harpoon.lua;

    extraPlugins = with pkgs.vimPlugins; [
      harpoon2
    ];

    keymaps = [
      {
        key = "<localleader>ha";
        action = "function() require('harpoon'):list():append() end";
        lua = true;
        options = {
          desc = "[H]arpoon [A]ppend";
        };
      }
      {
        key = "<leader>hw";
        action = ''function()
          local harpoon = require('harpoon')
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end'';
        lua = true;
        options = {
          desc = "[H]arpoon [W]indow";
        };
      }
    ];
  };
}
