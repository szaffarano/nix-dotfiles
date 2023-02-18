{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
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
}
