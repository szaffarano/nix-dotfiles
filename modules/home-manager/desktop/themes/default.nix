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
          size = 12.0;
          style = "";
        };
      };

      gtk = {
        theme = "Adwaita-dark";
        cursor-theme = "Adwaita";
        icon-theme = "Papirus";
        font = font // {
          size = 11;
        };
        font-mono = fontMono // {
          size = 11;
        };
        icon-theme-pkg = pkgs.papirus-icon-theme;
        theme-pkg = pkgs.gnome-themes-extra;
      };

      wezterm = {
        fonts = fontMono // {
          size = 13;
        };
        theme = "Catppuccin Frappe";
      };

      kitty = {
        fonts = fontMono // {
          size = 13;
        };
        theme = "Catppuccin-Frappe";
      };

      waybar = {
        colors = with config.colorscheme.palette; {
          c-bg-primary = "#${base00}";
          c-fg-primary = "#${base04}";
          c-fg-secondary = "#${base02}";
          c-critical = "#${base09}";
          c-warning = "#${base0B}";
          c-ok = "#${base0A}";
          c-muted = "#${base0F}";
          c-neutral = "#${base06}";
        };

        fonts = {
          f-family = fontMono.family;
          f-name = fontMono.name;
          f-size = fontMono.size;
        };
      };

      # Theme colourscheme
      colourscheme = rec {
        # Background
        bg-primary = black;
        bg-dark-primary = "#16161d";
        bg-bright-primary = bright-black;
        bg-secondary = dark-grey;
        bg-dark-secondary = "#122027";
        bg-bright-secondary = bright-dark-grey;

        # Foreground
        fg-primary = white;
        fg-bright-primary = bright-white;
        fg-secondary = light-grey;
        fg-bright-secondary = bright-light-grey;

        # Additional
        accent-primary = blue;
        accent-secondary = green;
        accent-tertiary = magenta;
        alert = red;
        warning = yellow;

        # Normal colours
        black = "#2e3440";
        red = "#bf616a";
        green = "#a3be8c";
        yellow = "#ebcb8b";
        blue = "#81a1c1";
        magenta = "#b48ead";
        cyan = "#88c0d0";
        white = "#e5e9f0";
        dark-grey = "#3b4252";
        light-grey = "#d8dee9";

        # Bright colours
        bright-black = "#434c5e";
        bright-red = "#cf717a";
        bright-green = "#b3ce9c";
        bright-yellow = "#fbdb9b";
        bright-blue = "#91b1d1";
        bright-magenta = "#c49ebd";
        bright-cyan = "#8fbcbb";
        bright-white = "#eceff4";
        bright-dark-grey = "#4c566a";
        bright-light-grey = "#e5e9f0";
      };
    };
  };
}
