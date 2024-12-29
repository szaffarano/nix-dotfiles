{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.gui.qt;
in
  with lib; {
    imports = [];

    options.desktop.gui.qt.enable = mkEnableOption "gtk";

    config = mkIf cfg.enable {
      qt = {
        enable = true;
        platformTheme = {
          name = "gtk";
        };
        style = {
          name = "gtk2";
          package = pkgs.qt6Packages.qt6gtk2;
        };
      };
    };
  }
