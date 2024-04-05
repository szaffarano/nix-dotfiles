{ config, lib, ... }:
let
  cfg = config.desktop.wayland.mako;

  iconThemePackage = config.gtk.iconTheme.package;
  iconPath = if kind == "dark" then "/share/icons/Papirus-Dark" else "/share/icons/Papirus-Light";

  inherit (config.colorscheme) palette kind;
in
with lib;
{
  options.desktop.wayland.mako.enable = mkEnableOption "mako";

  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      iconPath = if config.desktop.gui.gtk.enable then "${iconThemePackage}/${iconPath}" else null;
      font = "${config.fontProfiles.regular.family} ${config.fontProfiles.regular.size}";
      padding = "10,20";
      anchor = "top-center";
      width = 400;
      height = 150;
      borderSize = 1;
      defaultTimeout = 12000;
      backgroundColor = "#${palette.base00}dd";
      borderColor = "#${palette.base03}dd";
      textColor = "#${palette.base05}dd";
      layer = "overlay";
    };
  };
}
