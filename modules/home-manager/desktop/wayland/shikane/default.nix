{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.desktop.wayland.shikane;
  shikaneCmd = "sleep 5 && ${lib.getExe pkgs.shikane}";
in
with lib;
{
  options.desktop.wayland.shikane = {
    enable = mkEnableOption "shikane";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      shikane
      wdisplays
    ];

    xdg.configFile."shikane/config.toml".source = ./config.toml;

    wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
      startup = [
        { command = shikaneCmd; }
      ];
    };

    wayland.windowManager.hyprland.settings =
      lib.mkIf config.desktop.wayland.compositors.hyprland.enable
        {
          exec-once = [ shikaneCmd ];
        };
  };
}
