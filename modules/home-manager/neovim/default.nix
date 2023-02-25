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

      extraLuaConfig = ''
        require('init')
      '';

      plugins = with pkgs.vimPlugins;
        [
          (pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
            with p; [
              bash
              c
              cpp
              go
              java
              kotlin
              lua
              python
              rust
              typescript
              nix
            ]))
        ];
    };
    xdg.configFile."nvim" = {
      source = ./config;
      recursive = true;
    };
  };
}
