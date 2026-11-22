{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.xorg.i3status-rust;
in
  with lib; {
    options.desktop.xorg.i3status-rust.enable = mkEnableOption "i3status-rust";

    config = mkIf cfg.enable {
      programs.i3status-rust = let
        iconToggleOff = builtins.fromJSON ''"\uf09c"'';
        iconToggleOn = builtins.fromJSON ''"\uf023"'';

        batteryState = {
          "0..20" = "critical";
          "21..70" = "warning";
          "71..100" = "good";
        };

        lockOff = pkgs.writeShellScript "lock-off" ''
          ${pkgs.systemd}/bin/systemctl --user stop xautolock-session.service xss-lock.service 2>/dev/null || true
          ${pkgs.xset}/bin/xset -dpms
          ${pkgs.xset}/bin/xset s off
        '';
        lockOn = pkgs.writeShellScript "lock-on" ''
          ${pkgs.systemd}/bin/systemctl --user start xautolock-session.service xss-lock.service 2>/dev/null || true
          ${pkgs.xset}/bin/xset +dpms
          ${pkgs.xset}/bin/xset s on
        '';
      in {
        enable = true;
        bars.default = {
          icons = "awesome4";
          theme = "plain";
          blocks = [
            {
              block = "disk_space";
              path = "/";
              info_type = "available";
              format = " $icon $available ";
              warning = 10.0;
              alert_unit = "GB";
            }
            {
              block = "memory";
              format = " $icon $mem_total_used_percents.eng(w:2) ";
              format_alt = " $icon_swap $swap_used_percents.eng(w:2) ";
            }
            {
              block = "cpu";
              interval = 2;
            }
            {
              block = "sound";
              click = [
                {
                  button = "left";
                  cmd = "pavucontrol";
                }
              ];
            }

            {
              block = "bluetooth";
              mac = "A8:E6:E8:6C:74:99";
              disconnected_format = "";
              format = " $icon ";
              battery_state = batteryState;
              click = [
                {
                  button = "left";
                  cmd = "${pkgs.blueman}/bin/blueman-manager";
                }
              ];
            }
            {
              block = "bluetooth";
              mac = "DC:2C:26:2C:EE:46";
              format = " $icon ";
              battery_state = batteryState;
              click = [
                {
                  button = "left";
                  cmd = "${pkgs.blueman}/bin/blueman-manager";
                }
              ];
            }
            {
              block = "time";
              format = " $timestamp.datetime(f:'%Y-%m-%d %R') ";
              interval = 5;
              click = [
                {
                  button = "left";
                  cmd = "${pkgs.zenity}/bin/zenity --calendar";
                }
              ];
            }
            {
              block = "toggle";
              command_on = lockOn;
              command_off = lockOff;
              command_state = "${pkgs.systemd}/bin/systemctl --user is-active --quiet xautolock-session.service && echo on";
              format = " $icon ";
              icon_off = "toggle_off";
              icon_on = "toggle_on";
              state_off = "warning";
              state_on = "idle";
              icons_overrides = {
                toggle_off = iconToggleOff;
                toggle_on = iconToggleOn;
              };
            }
            {
              block = "notify";
              driver = "dunst";
              click = [
                {
                  button = "left";
                  action = "show";
                }
                {
                  button = "right";
                  action = "toggle_paused";
                }
              ];
            }
          ];
        };
      };
    };
  }
