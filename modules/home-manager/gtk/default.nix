_:
{ config, lib, pkgs, theme, ... }:
let
  # TODO: marameterize
  font = "Liberation Mono";
  icon_theme = "Papirus";
  theme = "Adwaita";
  icon_theme_pkg = pkgs.papirus-icon-theme;
  theme_pkg = pkgs.gnome-themes-extra;
in
{
  options.gtk.config.enable = lib.mkEnableOption "gtk.config";

  config = lib.mkIf config.gtk.config.enable {
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
          gtk-font-name = font;
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
      };
      gtk2 = {
        extraConfig = ''
          gtk-font-name="${font}"
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
  };
}
