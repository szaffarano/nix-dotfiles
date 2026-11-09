{
  config,
  lib,
  ...
}: let
  feature_name = "i3";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  config = {
    services.xserver = lib.mkIf enabled {
      enable = true;
      windowManager.i3.enable = true;
      displayManager.startx.enable = true;
    };
    security.polkit = lib.mkIf enabled {
      enable = true;
    };

    nixos.custom.features.register = feature_name;
  };
}
