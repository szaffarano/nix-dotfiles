{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.desktop.wayland.compositors;
  nmAppletCmd = "${pkgs.networkmanagerapplet}/bin/nm-applet";
  paSysTrayCmd = "${pkgs.pasystray}/bin/pasystray";
in
with lib;
{
  imports = [
    ./hyprland
    ./sway
  ];

  options.desktop.wayland.compositors.enable = mkEnableOption "wayland compositors";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ gsettings-desktop-schemas ];

    xdg.systemDirs.data = [ "${pkgs.networkmanagerapplet}/share" ];

    wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
      startup = [
        { command = "sleep 6 && ${nmAppletCmd}"; }
        { command = "sleep 6 && ${paSysTrayCmd}"; }
      ];
    };

    wayland.windowManager.hyprland.settings =
      lib.mkIf config.desktop.wayland.compositors.hyprland.enable
        {
          exec-once = [
            "sleep 6 && ${nmAppletCmd}"
            "sleep 6 && ${paSysTrayCmd}"
          ];
        };

  };
}
