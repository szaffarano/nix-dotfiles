{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.shikane;
in
  with lib; {
    options.desktop.wayland.shikane = {
      enable = mkEnableOption "shikane";
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        shikane
        wdisplays
      ];

      xdg.configFile."shikane/config.toml".source = ./config.toml;

      systemd.user.services.shikane = {
        Install = {WantedBy = [config.wayland.systemd.target];};

        Unit = {
          ConditionEnvironment = "WAYLAND_DISPLAY";
          Description = "shikane";
          PartOf = [config.wayland.systemd.target];
          After = [config.wayland.systemd.target];
          X-Restart-Triggers = ["${config.xdg.configFile."shikane/config.toml".source}"];
        };

        Service = {
          ExecStart = "${lib.getExe pkgs.shikane}";
          Restart = "always";
          RestartSec = "10";
        };
      };
    };
  }
