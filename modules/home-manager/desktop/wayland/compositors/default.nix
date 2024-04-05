{ config, lib, ... }:
let
  cfg = config.desktop.wayland.compositors;
in
with lib;
{

  imports = [
    ./hyprland
    ./sway
  ];

  options.desktop.wayland.compositors.enable = mkEnableOption "wayland compositors";

  config = mkIf cfg.enable { home.packages = with pkgs; [ gsettings-desktop-schemas ]; };
}
