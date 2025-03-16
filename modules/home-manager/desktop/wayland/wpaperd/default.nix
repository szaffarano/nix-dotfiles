{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.wpaperd;
  refreshWallpapersCmd = ''${pkgs.imagemagick}/bin/magick "$(${lib.getExe pkgs.wallpaper})" ${config.home.homeDirectory}/Pictures/screen-lock.png'';
in
  with lib; {
    options.desktop.wayland.wpaperd.enable = mkEnableOption "wpaperd";

    config = mkIf cfg.enable {
      systemd.user.services.refresh-wallpapers = {
        Unit = {
          Description = "Refresh wallpapers folder and updates screen-lock image.";
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.bash} -c '${refreshWallpapersCmd}'";
        };
      };
      systemd.user.timers.refresh-wallpapers = {
        Unit = {
          Description = "Refresh wallpapers.";
        };
        Timer = {
          OnBootSec = "30m";
          OnUnitActiveSec = "30m";
        };
        Install.WantedBy = ["timers.target"];
      };

      services.wpaperd = {
        enable = true;
        settings = {
          default = {
            duration = "30m";
            mode = "fit";
            sorting = "random";
            path = "${config.home.homeDirectory}/Pictures/wallpapers";
            queue-size = 30;
          };
        };
      };

      wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
        startup = [{command = "${lib.getExe pkgs.wpaperd} -d";}];
      };

      wayland.windowManager.hyprland.settings = lib.mkIf config.desktop.wayland.compositors.hyprland.enable {
        exec-once = ["${lib.getExe pkgs.wpaperd} -d"];
      };
    };
  }
