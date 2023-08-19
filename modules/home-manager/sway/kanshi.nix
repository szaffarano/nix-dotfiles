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
