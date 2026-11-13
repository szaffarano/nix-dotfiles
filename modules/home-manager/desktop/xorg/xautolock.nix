{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.xorg.xautolock;
in
  with lib; {
    options.desktop.xorg.xautolock.enable = mkEnableOption "screen locker (xss-lock + xautolock)";

    config = mkIf cfg.enable {
      services.screen-locker = {
        enable = true;
        inactiveInterval = 10;
        lockCmd = "${pkgs.i3lock-color}/bin/i3lock-color --color ${config.colorScheme.palette.base00}";
        xautolock.enable = true;
      };
    };
  }
