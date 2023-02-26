_:
{ config, lib, pkgs, ... }: {
  options.keepassxc.enable = lib.mkEnableOption "keepassxc";

  config = lib.mkIf config.keepassxc.enable {

    xdg.configFile."keepassxc" = {
      source = ./keepassxc.ini;
      target = "keepassxc/keepassxc.ini";
    };

    home.packages = with pkgs; [ keepassxc ];
  };
}
