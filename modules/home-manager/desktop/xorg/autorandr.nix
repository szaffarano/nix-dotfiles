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

      xsession.windowManager.i3.config.keybindings = let
        cmd = "${config.programs.autorandr.package}/bin/autorandr";
      in {
        "Control+Mod1+d" = "exec ${cmd} --cycle";
      };
    };
  }
