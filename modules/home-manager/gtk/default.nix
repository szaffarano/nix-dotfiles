_:
{ config, lib, pkgs, theme, ... }:
let
  font = theme.gtk.font.name;
  icon_theme = theme.gtk.icon-theme;
  gtk-theme = theme.gtk.theme;
  icon-theme-pkg = theme.gtk.icon-theme-pkg;
  theme-pkg = theme.gtk.theme-pkg;
in
{
  options.gtk.config.enable = lib.mkEnableOption "gtk.config";

  config = lib.mkIf config.gtk.config.enable {
    gtk = {
      enable = true;
      iconTheme = {
        name = icon_theme;
        package = icon-theme-pkg;
      };
      theme = {
        name = gtk-theme;
        package = theme-pkg;
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
