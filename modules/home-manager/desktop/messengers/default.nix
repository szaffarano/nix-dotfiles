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
    custom.unfree.packages = with pkgs; [
      zoom-us
      slack
      telegram-desktop
    ];
    home.packages = with pkgs; [
      zoom-us
      slack
      telegram-desktop
    ];
  };
}
