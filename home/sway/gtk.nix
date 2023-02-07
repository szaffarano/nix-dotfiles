{ config, pkgs, ... }:
let
  icon_theme = "Adwaita";
  theme = icon_theme;
  icon_theme_pkg = pkgs.gnome.adwaita-icon-theme;
  theme_pkg = pkgs.gnome-themes-extra;
in {
  wayland.windowManager.sway.extraConfig = ''
    seat seat0 xcursor_theme ${theme}
  '';

  gtk = {
    enable = true;
    iconTheme = {
      name = icon_theme;
      package = icon_theme_pkg;
    };
    theme = {
      name = theme;
      package = theme_pkg;
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-font-name = "Liberation Sans 11";
        gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = 1;
        gtk-menu-images = 1;
        gtk-enable-event-sounds = 1;
        gtk-enable-input-feedback-sounds = 1;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintfull";
      };
      extraCss = ''
        /** Some apps use titlebar class and some window */
        .titlebar,
        window {
          border-radius: 0;
          box-shadow: none;
        }

        /** also remove shaddows */
        decoration {
          box-shadow: none;
        }

        decoration:backdrop {
          box-shadow: none;
        }
      '';
    };
    gtk2 = {
      extraConfig = ''
        gtk-font-name="Liberation Sans 11"
        gtk-toolbar-style=GTK_TOOLBAR_BOTH
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=1
        gtk-menu-images=1
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=1
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintfull"
      '';
    };
  };

  home.file.".themes".source = config.lib.file.mkOutOfStoreSymlink
    ("${config.home.homeDirectory}/.nix-profile/share/themes");
  xdg.dataFile."icons".source = config.lib.file.mkOutOfStoreSymlink
    ("${config.home.homeDirectory}/.nix-profile/share/icons");
}
