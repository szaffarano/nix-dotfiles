{ config
, lib
, pkgs
, ...
}:
let
  feature_name = "laptop";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  config = {
    services = lib.mkIf enabled {
      upower.enable = true;
      thermald.enable = true;
    };

    powerManagement.powertop.enable = enabled;

    environment.systemPackages = with pkgs; lib.optionals enabled [ powertop ];
    nixos.custom.features.register = feature_name;
  };
}
