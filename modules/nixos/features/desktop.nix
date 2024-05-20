{ config, lib, ... }:
let
  feature_name = "desktop";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  config = {
    services = lib.mkIf enabled {
      greetd.enable = lib.mkDefault false;
      geoclue2.enable = lib.mkDefault true;
    };

    hardware = lib.mkIf enabled {
      bluetooth.enable = true;
      opengl.enable = true;
    };
    programs = lib.mkIf enabled { dconf.enable = true; };

    nixos.custom.features.register = feature_name;
  };
}
