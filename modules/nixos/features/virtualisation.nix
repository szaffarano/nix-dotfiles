{
  config,
  lib,
  pkgs,
  ...
}: let
  feature_name = "virtualisation";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  config = {
    virtualisation = lib.mkIf enabled {
      libvirtd.enable = true;
      docker = {
        enable = lib.mkForce true;
        storageDriver = "btrfs";
      };
    };
    environment.systemPackages = lib.mkIf enabled [pkgs.cosign];

    nixos.custom.features.register = feature_name;
  };
}
