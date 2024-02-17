{ config, lib, pkgs, ... }:
let cfg = config.desktop.wayland.swaync;
in with lib; {
  options.desktop.wayland.swaync.enable = mkEnableOption "swaync";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ swaynotificationcenter libnotify ];

    xdg.configFile.swaync-settings = {
      source = ./config.json;
      target = "swaync/config.json";
    };

    # TODO: use config.colorscheme
    xdg.configFile.swaync-style = {
      target = "swaync/style.css";
      text = builtins.readFile ./style.css;
    };
  };
}
