{ pkgs, config, ... }:
let
  font = config.fontProfiles.regular;
  fontMono = config.fontProfiles.monospace;
in
{
  _module.args = {
    theme = {
      gtk = {
        theme = "Adwaita-dark";
        cursor-theme = "Adwaita";
        icon-theme = "Papirus";
        font = font // {
          size = 10;
        };
        font-mono = fontMono // {
          size = 10;
        };
        icon-theme-pkg = pkgs.papirus-icon-theme;
        theme-pkg = pkgs.gnome-themes-extra;
      };
    };
  };
}
