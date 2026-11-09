{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.xorg.rofi;
  rofi = "${pkgs.rofi}/bin/rofi";
  greenclipPkg = pkgs.haskellPackages.greenclip;
  greenclip = "${greenclipPkg}/bin/greenclip";
in
  with lib; {
    options.desktop.xorg.rofi.enable = mkEnableOption "rofi";

    config = mkIf cfg.enable {
      home.packages = [greenclipPkg];

      programs.rofi = {
        enable = true;
        package = pkgs.rofi;
        settings.terminal = config.home.sessionVariables.TERMINAL;
      };

      xsession.windowManager.i3.config = mkIf config.desktop.xorg.compositors.i3.enable {
        startup = [
          {
            command = "${greenclip} daemon";
            always = true;
            notification = false;
          }
        ];

        keybindings = {
          "Mod4+d" = "exec ${rofi} -show drun";
          "Mod4+Shift+v" = "exec ${rofi} -modi 'clipboard:${greenclip} print' -show clipboard -run-command '{cmd}'";
        };
      };
    };
  }
