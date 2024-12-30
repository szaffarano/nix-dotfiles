{
  config,
  lib,
  pkgs,
  ...
}: let
  feature_name = "yubikey";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  config = {
    services = lib.mkIf enabled {
      pcscd = {
        enable = true;
        plugins = with pkgs; [ccid];
      };
      udev.packages = with pkgs; [yubikey-personalization];
    };

    environment.systemPackages = with pkgs; lib.mkIf enabled [pcsc-tools];

    nixos.custom.features.register = feature_name;
  };
}
