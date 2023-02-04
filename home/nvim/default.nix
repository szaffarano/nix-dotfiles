{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      :lua require('init')
    '';
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (plugins:
        with plugins; [
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
