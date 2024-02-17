{ config, lib, ... }:
let cfg = config.nixos.desktop.sway;

in {
  options.nixos.desktop.sway.enable = lib.mkEnableOption "sway";

  config = lib.mkIf cfg.enable {
    security.pam.services = { swaylock = { }; };
    programs.sway.enable = true;
  };
}
