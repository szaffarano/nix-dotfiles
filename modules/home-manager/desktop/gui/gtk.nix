{ config
, lib
, theme
, ...
}:
let
  cfg = config.desktop.gui.gtk;

  font = theme.gtk.font;
  icon-theme = theme.gtk.icon-theme;
  gtk-theme = theme.gtk.theme;
  icon-theme-pkg = theme.gtk.icon-theme-pkg;
  theme-pkg = theme.gtk.theme-pkg;
in
with lib;
{
  imports = [ ];

  options.desktop.gui.gtk.enable = mkEnableOption "gtk";

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      font = {
        name = font.name;
        size = font.size;
      };
      iconTheme = {
        name = icon-theme;
        package = icon-theme-pkg;
      };
      theme = {
        name = gtk-theme;
        package = theme-pkg;
      };
    };

    # workaround for non-NixOS systems
    home.file.".themes".source = config.lib.file.mkOutOfStoreSymlink (
      "${config.home.homeDirectory}/.nix-profile/share/themes"
    );
    xdg.dataFile."icons".source = config.lib.file.mkOutOfStoreSymlink (
      "${config.home.homeDirectory}/.nix-profile/share/icons"
    );

    services.xsettingsd = {
      enable = true;
      settings = {
        "Net/ThemeName" = gtk-theme;
        "Net/IconThemeName" = icon-theme;
      };
    };
  };
}
