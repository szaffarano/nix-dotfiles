{...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      :lua require('init')
    '';
  };
  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
}
