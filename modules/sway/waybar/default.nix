{ config, lib, pkgs, ... }: {
  imports = [ ./cjbassi ./slithery0 ];
  options.waybar.enable = lib.mkEnableOption "waybar";

  config = lib.mkIf config.waybar.enable {
    xdg.configFile.waybar = {
      source = ./extra;
      target = "waybar/extra";
    };

    cjbassi.enable = true;
    slithery0.enable = false;

    wayland.windowManager.sway.config.bars = [{ command = "waybar"; }];

    programs.waybar = { enable = true; };
  };
}
