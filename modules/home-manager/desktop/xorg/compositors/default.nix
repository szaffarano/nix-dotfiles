{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.xorg.compositors;
  nmAppletCmd = "${pkgs.networkmanagerapplet}/bin/nm-applet";
  paSysTrayCmd = "${pkgs.pasystray}/bin/pasystray";
in
  with lib; {
    imports = [
      ./i3
    ];

    options.desktop.xorg.compositors.enable = mkEnableOption "xorg compositors";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [gsettings-desktop-schemas];

      xdg.systemDirs.data = ["${pkgs.networkmanagerapplet}/share"];

      xsession.windowManager.i3.config.startup = lib.mkIf config.desktop.xorg.compositors.i3.enable [
        {
          command = "${nmAppletCmd}";
          notification = false;
        }
        {
          command = "${paSysTrayCmd}";
          notification = false;
        }
      ];
    };
  }
