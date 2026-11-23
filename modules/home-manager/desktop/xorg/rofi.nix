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
  powerMenu = "${rofi} -show p -modi 'p:${lib.getExe pkgs.rofi-power-menu} --choices=suspend/logout/lockscreen/reboot/shutdown/hibernate' -theme-str 'window {width: 8em;} listview {lines: 5; scrollbar: false;}'";
in
  with lib; {
    options.desktop.xorg.rofi.enable = mkEnableOption "rofi";

    config = mkIf cfg.enable {
      home.packages = [
        greenclipPkg
        pkgs.rofi-power-menu
      ];

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
          "Mod4+d" = "exec ${rofi} -show run";
          "Mod4+x" = "exec ${rofi} -show drun";
          "Mod4+BackSpace" = ''exec "${powerMenu}"'';
          "Ctrl+Mod1+v" = "exec ${rofi} -modi 'clipboard:${greenclip} print' -show clipboard -run-command '{cmd}'";
        };
      };
    };
  }
