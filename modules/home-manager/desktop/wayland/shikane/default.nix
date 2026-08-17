{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.shikane;
  shikaneDual = "${pkgs.shikane}/bin/shikanectl switch docked-dual-A-sw-carbon";
  shikaneSingle = "${pkgs.shikane}/bin/shikanectl switch docked-single-B-sw-carbon";
  shikaneAsus = "${pkgs.shikane}/bin/shikanectl switch asus-only-sw-carbon";
  shikaneUndocked = "${pkgs.shikane}/bin/shikanectl switch undocked-sw-carbon";
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
          "Ctrl+Alt+D" = "exec ${shikaneDual}";
          "Ctrl+Alt+S" = "exec ${shikaneSingle}";
          "Ctrl+Alt+A" = "exec ${shikaneAsus}";
          "Ctrl+Alt+U" = "exec ${shikaneUndocked}";
        };
      };

      wayland.windowManager.hyprland.settings =
        lib.mkIf config.desktop.wayland.compositors.hyprland.enable
        {
          bind = [
            {
              _args = ["CTRL + ALT + D" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON shikaneDual})")];
            }
            {
              _args = ["CTRL + ALT + S" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON shikaneSingle})")];
            }
            {
              _args = ["CTRL + ALT + A" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON shikaneAsus})")];
            }
            {
              _args = ["CTRL + ALT + U" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON shikaneUndocked})")];
            }
          ];
        };
    };
  }
