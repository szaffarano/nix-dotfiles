{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.xorg.dunst;
  inherit (config.fontProfiles) monospace;
  colors = config.colorScheme.palette;
in
  with lib; {
    options.desktop.xorg.dunst.enable = mkEnableOption "dunst";

    config = mkIf cfg.enable {
      services.dunst = {
        enable = true;
        settings = {
          global = {
            font = "${monospace.name} 10";
            frame_width = 2;
            frame_color = "#${colors.base0D}";
            separator_color = "frame";
            corner_radius = 4;
            offset = "12x12";
            origin = "bottom-right";
          };
          urgency_low = {
            background = "#${colors.base00}";
            foreground = "#${colors.base05}";
          };
          urgency_normal = {
            background = "#${colors.base00}";
            foreground = "#${colors.base05}";
          };
          urgency_critical = {
            background = "#${colors.base08}";
            foreground = "#${colors.base00}";
            frame_color = "#${colors.base08}";
          };
        };
      };

      xsession.windowManager.i3.config.keybindings = let
        dunstctl = "${pkgs.dunst}/bin/dunstctl";
      in {
        "Ctrl+Mod1+space" = "exec ${dunstctl} close";
        "Ctrl+Mod1+Shift+space" = "exec ${dunstctl} history-pop";
      };
    };
  }
