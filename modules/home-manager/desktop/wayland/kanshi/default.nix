{ config
, lib
, pkgs
, ...
}:
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
    home.packages = with pkgs; [ kanshi ];

    services.kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
      settings = [
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        }
        {
          profile.name = "docked-home";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "HDMI-A-1";
              status = "enable";
            }
          ];
        }
        {
          profile.name = "docked-home-sw";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "DP-1";
              status = "enable";
            }
          ];
        }
        {
          profile.name = "docked-home-alt-sw";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "DP-2";
              status = "enable";
            }
          ];
        }
      ];
    };
  };
}
