{ pkgs, ... }: {
  fontProfiles = {
    enable = true;
    monospace = {
      family = "sans-serif";
      name = "FiraCode Nerd Font";
      size = "15px";
      package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
    };
    regular = {
      family = "liberation-sans";
      name = "Liberation Sans";
      size = "11px";
      package = pkgs.liberation_ttf;
    };
  };
}
