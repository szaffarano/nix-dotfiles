{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.xorg.autorandr;
in
  with lib; {
    options.desktop.xorg.autorandr.enable = mkEnableOption "autorandr";

    config = mkIf cfg.enable {
      programs.autorandr.enable = true;
    };
  }
