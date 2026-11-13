{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.xorg.flameshot;
in
  with lib; {
    options.desktop.xorg.flameshot.enable = mkEnableOption "flameshot";

    config = mkIf cfg.enable {
      services.flameshot.enable = true;

      xsession.windowManager.i3.config.keybindings = mkIf config.desktop.xorg.compositors.i3.enable {
        "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui";
      };
    };
  }
