{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.tools.copyq;
in
  with lib; {
    options.desktop.tools.copyq.enable = mkEnableOption "copyq";

    config = mkIf cfg.enable {
      xdg.configFile."copyq/copyq.conf".source = ./config/copyq.conf;
      xdg.configFile."copyq/copyq-commands.ini".source = ./config/copyq-commands.ini;
      wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.hyprland.enable {
        floating.criteria = [{app_id = "copyq";}];
        keybindings = {
          "Ctrl+Alt+v" = "exec copyq toggle";
        };
      };
      wayland.windowManager.hyprland = lib.mkIf config.desktop.wayland.compositors.hyprland.enable {
        settings = {
          bind = [
            {
              _args = [
                "CTRL + ALT + v"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("copyq toggle")'')
              ];
            }
          ];
          window_rule = [
            {
              match.class = "^(com.github.hluk.copyq)$";
              float = true;
            }
          ];
        };
      };

      home.packages = with pkgs; [copyq];
      services.copyq.enable = false;
    };
  }
