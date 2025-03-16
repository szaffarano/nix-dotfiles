{
  config,
  lib,
  ...
}: let
  feature_name = "sway";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  config = {
    programs.sway = lib.mkIf enabled {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    security.polkit = lib.mkIf enabled {
      enable = true;
    };

    nixos.custom.features.register = feature_name;
  };
}
