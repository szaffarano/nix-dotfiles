{
  config,
  lib,
  theme,
  ...
}: let
  cfg = config.desktop.gui.qt;
in
  with lib; {
    imports = [];

    options.desktop.gui.qt.enable = mkEnableOption "qt";

    config = mkIf cfg.enable {
      qt = {
        enable = true;
        platformTheme = {
          name = theme.platform-theme;
        };
        style.name = theme.gtk.theme;
      };
    };
  }
