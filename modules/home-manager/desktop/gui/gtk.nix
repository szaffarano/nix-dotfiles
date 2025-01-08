{
  config,
  lib,
  theme,
  pkgs,
  ...
}: let
  cfg = config.desktop.gui.gtk;

  inherit
    (theme.gtk)
    font
    icon-theme
    icon-theme-pkg
    theme-pkg
    ;
  gtk-theme = theme.gtk.theme;
in
  with lib; {
    imports = [];

    options.desktop.gui.gtk.enable = mkEnableOption "gtk";

    config = mkIf cfg.enable {
      xdg.portal = {
        config = {
          common = {
            default = ["gtk"];
          };
        };
        extraPortals = with pkgs; [xdg-desktop-portal-gtk];
      };
      gtk = {
        enable = true;
        font = {inherit (font) size name;};
        iconTheme = {
          name = icon-theme;
          package = icon-theme-pkg;
        };
        theme = {
          name = gtk-theme;
          package = theme-pkg;
        };
      };

      services.xsettingsd = {
        enable = true;
        settings = {
          "Net/ThemeName" = gtk-theme;
          "Net/IconThemeName" = icon-theme;
        };
      };
    };
  }
