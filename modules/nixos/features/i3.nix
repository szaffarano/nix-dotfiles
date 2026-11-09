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
      autoRepeatDelay = 250;
      autoRepeatInterval = 25;

      xkb = {
        layout = "us";
        variant = "intl";
        options = "grp:ctrl_alt_toggle";
      };
    };
    security.polkit = lib.mkIf enabled {
      enable = true;
    };

    services.autorandr = {
      enable = true;
    };

    nixos.custom.features.register = feature_name;
  };
}
