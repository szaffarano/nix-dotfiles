{
  config,
  lib,
  pkgs,
  ...
}: {
  config = with config.programs;
    lib.mkIf (sway.enable || hyprland.enable) {
      xdg.portal = {
        enable = lib.mkDefault true;
        wlr.enable = sway.enable;
        xdgOpenUsePortal = lib.mkDefault false;
        extraPortals = with pkgs;
          lib.mkDefault [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
          ];
      };
    };
}
