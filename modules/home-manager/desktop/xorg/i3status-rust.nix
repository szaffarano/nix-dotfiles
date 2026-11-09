{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.xorg.i3status-rust;
in
  with lib; {
    options.desktop.xorg.i3status-rust.enable = mkEnableOption "i3status-rust";

    config = mkIf cfg.enable {
      programs.i3status-rust = {
        enable = true;
        bars.default = {
          icons = "awesome6";
          theme = "gruvbox-dark";
          blocks = [
            {
              block = "disk_space";
              path = "/";
              info_type = "available";
              format = " $icon $available ";
            }
            {
              block = "memory";
              format = " $icon $mem_used_percents ";
            }
            {
              block = "cpu";
              interval = 2;
            }
            {
              block = "sound";
            }
            {
              block = "battery";
              format = " $icon $percentage ";
            }
            {
              block = "time";
              interval = 5;
              format = " $timestamp.datetime(f:'%Y-%m-%d %R') ";
            }
          ];
        };
      };
    };
  }
