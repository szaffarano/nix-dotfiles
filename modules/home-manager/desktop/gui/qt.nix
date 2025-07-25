{
  config,
  lib,
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
          name = "gtk3";
        };
      };
    };
  }
