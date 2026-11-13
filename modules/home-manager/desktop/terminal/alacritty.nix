{
  config,
  lib,
  ...
}: let
  inherit (config.fontProfiles) monospace;
  cfg = config.desktop.terminal.alacritty;
in
  with lib; {
    options.desktop.terminal.alacritty.enable = mkEnableOption "alacritty";

    config = mkIf cfg.enable {
      home = {
        sessionVariables = {
          TERMINAL = "alacritty";
        };
      };

      programs.alacritty = {
        enable = true;
        settings = {
          font = {
            normal.family = monospace.name;
            size = monospace.sizeAsInt * 0.9;
          };

          selection.save_to_clipboard = true;

          colors = with config.colorScheme.palette; {
            primary = {
              background = "#${base00}";
              foreground = "#${base05}";
            };
            normal = {
              black = "#${base00}";
              red = "#${base08}";
              green = "#${base0B}";
              yellow = "#${base0A}";
              blue = "#${base0D}";
              magenta = "#${base0E}";
              cyan = "#${base0C}";
              white = "#${base05}";
            };
            bright = {
              black = "#${base03}";
              red = "#${base08}";
              green = "#${base0B}";
              yellow = "#${base0A}";
              blue = "#${base0D}";
              magenta = "#${base0E}";
              cyan = "#${base0C}";
              white = "#${base07}";
            };
          };
        };
      };
    };
  }
