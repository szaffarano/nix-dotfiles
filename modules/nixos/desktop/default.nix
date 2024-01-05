{ config, lib, pkgs, ... }:
let cfg = config.nixos.desktop;

in {
  imports = [ ./greeter ./hyprland ./sway ];

  options.nixos.desktop.enable = lib.mkEnableOption "desktop";

  config = lib.mkIf cfg.enable {
    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    };

    programs = { dconf.enable = true; };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      xdgOpenUsePortal = false;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
