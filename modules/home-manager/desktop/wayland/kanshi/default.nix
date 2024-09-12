{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.desktop.wayland.kanshi;
  kanshiCmd = lib.getExe pkgs.kanshi;
in
with lib;
{
  options.desktop.wayland.kanshi = {
    enable = mkEnableOption "kanshi";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ kanshi ];

    wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
      startup = [
        { command = kanshiCmd; }
      ];
    };

    wayland.windowManager.hyprland.settings =
      lib.mkIf config.desktop.wayland.compositors.hyprland.enable
        {
          exec-once = [ kanshiCmd ];
        };

    services.kanshi = {
      enable = true;
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
              criteria = "LG Electronics LG HDR 4K 301MAPNGQZ84";
              status = "enable";
            }
          ];
        }
      ];
    };
  };
}
