_:
{ config, lib, pkgs, ... }:

{
  options.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf config.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withPython3 = true;
      withRuby = false;

      extraLuaConfig = builtins.readFile ./init.lua;
    };

    home.packages = with pkgs; [ tree-sitter gcc ];

    xdg.configFile.nvim = {
      source = ./config;
      recursive = true;
    };

    xdg.dataFile."nvim/templates" = {
      source = ./templates;
      recursive = true;
    };
  };
}
