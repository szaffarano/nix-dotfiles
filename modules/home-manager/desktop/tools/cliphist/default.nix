{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.tools.cliphist;
  fmt = pkgs.formats.toml {};
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
    options.desktop.tools.cliphist = {
      enable = mkEnableOption "cliphist";
      settings = mkOption {
        inherit (fmt) type;
        description = "rofi-cliphist.toml contents";
        default = {
          text_mode_config = {
            title = "Text";
            shortcut = "Ctrl+t";
            description = "Switch to text mode";
          };
          image_mode_config = {
            title = "Image";
            shortcut = "Ctrl+i";
            description = "Switch to image mode!";
          };
          delete_mode_config = {
            title = "Delete";
            shortcut = "Ctrl+x";
            description = "Delete entry";
          };
        };
      };
    };

    config = let
      watchCmd = lib.getExe clipboardWatch;
      rofiCmd = lib.getExe pkgs.inputs.rofi-tools.rofi-cliphist;
    in
      mkIf cfg.enable {
        home.packages = with pkgs; [
          cliphist
          wl-clipboard
        ];
        xdg.configFile."rofi-cliphist.toml".source =
          fmt.generate "config.toml" cfg.settings;

        wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
          startup = [{command = watchCmd;}];
          keybindings = {
            "Ctrl+Alt+v" = "exec ${rofiCmd}";
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
