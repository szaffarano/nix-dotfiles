{ config
, lib
, localLib
, pkgs
, ...
}:
let
  cfg = config.desktop.wayland.compositors.hyprland;
in
with lib;
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ hypridle ];

    services.hypridle.enable = true;
    xdg.configFile."hypr/hypridle.conf".text = localLib.toHyprconf
      {
        general =
          let
            lockCmd = lib.getExe pkgs.hyprlock;
            lockCmdImmediate = "${lib.getExe pkgs.hyprlock} --immediate";
          in
          {
            lock_cmd = "pidof hyprlock || ${lockCmd}";
            before_sleep_cmd = "pidof hyprlock || ${lockCmdImmediate}";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

        listener = [
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 3600;
            on-timeout = "systemctl suspend";
          }
        ];
      } 0;
  };
}
