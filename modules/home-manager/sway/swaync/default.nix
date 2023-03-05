{ config, pkgs, lib, theme, ... }:
{
  options.swaync.enable = lib.mkEnableOption "swaync";

  config = lib.mkIf config.swaync.enable {

    home.packages = [
      pkgs.swaynotificationcenter
    ];

    xdg.configFile.swaync-settings = {
      source = ./config.json;
      target = "swaync/config.json";
    };
    xdg.configFile.swaync-style = {
      target = "swaync/style.css";
      text = builtins.readFile ./style.css;
    };
  };
}
