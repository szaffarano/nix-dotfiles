{ pkgs, ... }:
{
  programs.nixvim = {
    extraConfigLua = builtins.readFile ./harpoon.lua;

    extraPlugins = with pkgs.vimPlugins; [
      harpoon2
    ];

    keymaps = [
      {
        key = "<M-C-a>";
        action = "function() require('harpoon'):list():append() end";
        lua = true;
        options = {
          desc = "[H]arpoon [A]ppend";
        };
      }
      {
        key = "<M-C-e>";
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
