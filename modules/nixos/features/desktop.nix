{
  config,
  lib,
  ...
}: let
  feature_name = "desktop";

  enable = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  config = {
    services = lib.mkIf enable {
      greetd.enable = lib.mkDefault false;
      geoclue2.enable = lib.mkDefault true;
    };

    environment = {
      enableAllTerminfo = true;
    };

    hardware = lib.mkIf enable {
      bluetooth.enable = true;
      graphics.enable = true;
    };
    programs.dconf = {
      inherit enable;
    };

    nixos.custom.features.register = feature_name;
  };
}
