_:
{ pkgs, ... }:
let
  font = {
    family = "";
    name = "Liberation Sans";
    size = "11px";
  };

  font-mono = {
    family = "sans-serif";
    name = "FiraCode Nerd Font";
    size = "15px";
  };
in
{
  _module.args = {
    theme = {
      fonts = {
        f-serif = "Noto Serif";
        f-sans-serif = "Noto Sans";
        f-mono = font-mono.name;
        f-emoji = "Noto Color Emoji";
      };

      sway = {
        fonts = font-mono // {
          size = 12.0;
          style = "";
        };
      };

      gtk = {
        theme = "Adwaita";
        cursor-theme = "Adwaita";
        icon-theme = "Papirus";
        font = font // { size = "11"; };
        font-mono = font-mono // { size = "11"; };
        icon-theme-pkg = pkgs.papirus-icon-theme;
        theme-pkg = pkgs.gnome-themes-extra;
      };

      kitty = {
        fonts = font-mono // { size = 13; };
        theme = "Catppuccin-Frappe";
      };

      waybar = {
        colors = {
          c-bg-primary = "#282828";
          c-fg-primary = "#ebdbb2";
          c-fg-secondary = "#fbf1c7";
          c-critical = "#fb4934";
          c-warning = "#d79921";
          c-ok = "#b9bb26";
          c-muted = "#928374";
          c-neutral = "#83a598";
        };

        fonts = {
          f-family = font-mono.family;
          f-name = font-mono.name;
          f-size = font-mono.size;
        };
      };
    };
  };
}
