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
      profiles = {
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        };
        home = {
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
      };
    };
  };
}
