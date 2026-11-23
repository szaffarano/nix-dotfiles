{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.xorg.i3lock;
in
  with lib; {
    options.desktop.xorg.i3lock.enable = mkEnableOption "i3lock-color";

    config = mkIf cfg.enable {
      home.packages = [pkgs.i3lock-color];
    };
  }
