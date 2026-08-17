{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.tools.keepassxc;
in
  with lib; {
    options.desktop.tools.keepassxc.enable = mkEnableOption "keepassxc";
    options.desktop.tools.keepassxc.autostart = mkEnableOption "keepassxc-autostart";

    config = mkIf cfg.enable {
      xdg.configFile."keepassxc" = {
        source = ./keepassxc.ini;
        target = "keepassxc/keepassxc.ini";
      };

      wayland.windowManager.sway.config.startup =
        lib.mkIf (config.desktop.wayland.compositors.sway.enable && cfg.autostart)
        [
          {
            command = "${pkgs.keepassxc}/bin/keepassxc";
          }
        ];

      wayland.windowManager.hyprland.extraConfig =
        lib.mkIf (
          config.desktop.wayland.compositors.hyprland.enable && cfg.autostart
        ) ''
          hl.on("hyprland.start", function()
            hl.exec_cmd(${builtins.toJSON "${pkgs.keepassxc}/bin/keepassxc"})
          end)
        '';

      home.packages = with pkgs; [keepassxc get-keepass-entry];
    };
  }
