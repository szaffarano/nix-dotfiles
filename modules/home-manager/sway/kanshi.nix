{ config, lib, pkgs, ... }: {
  options.kanshi.enable = lib.mkEnableOption "kanshi";

  config = lib.mkIf config.kanshi.enable {
    services.kanshi = {
      enable = true;
      systemdTarget = "";
      profiles = {
        undocked = {
          outputs = [{
            criteria = "eDP-1";
            status = "enable";
          }];
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
      };
    };
  };
}
