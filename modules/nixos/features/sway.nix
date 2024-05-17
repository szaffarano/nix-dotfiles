{ config, ... }:
let
  feature_name = "sway";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  config = {
    programs = {
      sway.enable = enabled;
    };

    nixos.custom.features.register = feature_name;
  };
}
