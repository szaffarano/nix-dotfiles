{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.desktop.messengers;
in
with lib;
{
  options.desktop.messengers.enable = mkEnableOption "desktop messengers";

  config = mkIf cfg.enable {
    home = {
      custom.allowed-unfree-packages = with pkgs; [
        zoom-us
        slack
        telegram-desktop
      ];
      packages = with pkgs; [
        zoom-us
        slack
        telegram-desktop
      ];
    };
  };
}
