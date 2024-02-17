{ config, lib, pkgs, ... }:
let cfg = config.desktop.tools.keepassxc;
in with lib; {

  options.desktop.tools.keepassxc.enable = mkEnableOption "keepassxc";

  config = mkIf cfg.enable {
    xdg.configFile."keepassxc" = {
      source = ./keepassxc.ini;
      target = "keepassxc/keepassxc.ini";
    };

    home.packages = with pkgs; [ keepassxc ];
  };
}
