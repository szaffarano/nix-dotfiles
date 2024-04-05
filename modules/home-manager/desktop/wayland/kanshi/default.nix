{ config, lib, ... }:
let
  cfg = config.desktop.wayland.kanshi;
in
with lib;
{
  options.desktop.wayland.kanshi = {
    enable = mkEnableOption "kanshi";
    lockTime = mkOption {
      type = types.int;
      default = 4 * 60;
      description = "Time in seconds before the screen is locked.";
    };
  };

  config = mkIf cfg.enable {
    services.kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
      profiles = {
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        };
        docked = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "HDMI-A-1";
              status = "enable";
            }
          ];
        };
        docked-work = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "HDMI-A-1";
              status = "enable";
            }
            {
              criteria = "DP-1";
              status = "disable";
            }
          ];
        };
        docked-alt = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "DP-1";
              status = "enable";
            }
          ];
        };
        docked-office = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "DP-2";
              status = "enable";
            }
          ];
        };
      };
    };
  };
}
