{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.shikane;
  shikaneDocked = "${pkgs.shikane}/bin/shikanectl switch docked-dual-B-sw";
  shikaneUndocked = "${pkgs.shikane}/bin/shikanectl switch docked-dual-A-sw";
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
          Environment = ["PATH=${config.home.profileDirectory}/bin"];
          ExecStart = "${lib.getExe pkgs.shikane}";
          Restart = "always";
          RestartSec = "10";
        };
      };

      wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
        keybindings = {
          "Ctrl+Alt+D" = "exec ${shikaneDocked}";
          "Ctrl+Alt+S" = "exec ${shikaneUndocked}";
        };
      };

      wayland.windowManager.hyprland.settings =
        lib.mkIf config.desktop.wayland.compositors.hyprland.enable
        {
          bind = [
            "CTRL_ALT,D,exec,${shikaneDocked}"
            "CTRL_ALT,S,exec,${shikaneUndocked}"
          ];
        };
    };
  }
