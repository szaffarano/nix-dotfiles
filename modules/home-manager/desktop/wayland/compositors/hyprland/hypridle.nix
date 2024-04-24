{ config
, lib
, outputs
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

    xdg.configFile."hypr/hypridle.conf".text =
      let
        hyprlockCmd = "${pkgs.hyprlock}/bin/hyprlock";
      in
      ''
        general {
          lock_cmd = pidof hyprlock || ${hyprlockCmd}
          before_sleep_cmd = loginctl lock-session
          after_sleep_cmd = hyprctl dispatch dpms on
        }

        listener {
          timeout =300
          on-timeout = loginctl lock-session
        }

        listener {
          timeout = 380
          on-timeout = hyprctl dispatch dpms off
          on-resume = hyprctl dispatch dpms on
        }

        listener {
          timeout =1800
          on-timeout = systemctl suspend
        }
      '';

    xdg.configFile."hypr/hypridle-test.conf".text = outputs.lib.toHyprconf
      {
        general =
          let
            hyprlockCmd = "${pkgs.hyprlock}/bin/hyprlock";
          in
          {
            lock_cmd = "pidof hyprlock || ${hyprlockCmd}";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

        # TODO not working, `toHyprconf` doesn't support attrsets
        # listener = [
        #   {
        #     timeout = 300;
        #     on-timeout = "loginctl lock-session";
        #   }
        #   {
        #     timeout = 380;
        #     on-timeout = "hyprctl dispatch dpms off";
        #     on-resume = "hyprctl dispatch dpms on";
        #   }
        #   {
        #     timeout = 1800;
        #     on-timeout = "systemctl suspend";
        #   }
        # ];
      } 0;
  };
}
