{ pkgs, config, ... }:
let
  font = config.fontProfiles.regular;
  fontMono = config.fontProfiles.monospace;
in
{
  _module.args = {
    theme = {
      fonts = {
        f-serif = "Noto Serif";
        f-sans-serif = "Noto Sans";
        f-mono = fontMono.name;
        f-emoji = "Noto Color Emoji";
      };

      sway = {
        fonts = fontMono // {
          size = 10.0;
          style = "";
        };
      };

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

      wezterm = {
        fonts = fontMono // {
          size = 10;
        };
        theme = "Catppuccin Frappe";
      };

      kitty = {
        fonts = fontMono // {
          size = 12;
        };
        theme = "Catppuccin-Frappe";
      };
    };
  };
}
