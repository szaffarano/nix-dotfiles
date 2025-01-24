{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.tools.cliphist;
  safeStore = pkgs.writeShellApplication {
    name = "safe-cliphist-store";
    runtimeInputs = with pkgs; [cliphist];
    text = builtins.readFile ./safe-cliphist-store.sh;
  };
  clipboardWatch = pkgs.writeShellApplication {
    name = "clipboard-watch";
    runtimeInputs = with pkgs; [
      procps
      safeStore
      wl-clipboard
    ];
    text = builtins.readFile ./clipboard-watch.sh;
  };
in
  with lib; {
    options.desktop.tools.cliphist.enable = mkEnableOption "cliphist";

    config = let
      watchCmd = lib.getExe clipboardWatch;
      rofiCmd = lib.getExe pkgs.inputs.rofi-tools.rofi-cliphist;
    in
      mkIf cfg.enable {
        home.packages = with pkgs; [
          cliphist
          wl-clipboard
        ];

        wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
          startup = [{command = watchCmd;}];
          keybindings = {
            "Ctrl+Alt+v" = "${rofiCmd}";
          };
        };

        wayland.windowManager.hyprland.settings =
          lib.mkIf config.desktop.wayland.compositors.hyprland.enable
          {
            bind = [
              "CTRL_ALT,v,exec,${rofiCmd}"
            ];
            exec-once = [watchCmd];
          };
      };
  }
