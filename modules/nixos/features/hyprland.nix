{ config, ... }:
let
  feature_name = "hyprland";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  config = {
    programs = {
      hyprland.enable = enabled;
    };

    nixos.custom.features.register = feature_name;
  };
}
