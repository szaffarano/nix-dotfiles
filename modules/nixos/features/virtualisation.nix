{ config, lib, ... }:
let
  feature_name = "virtualisation";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  config = {
    virtualisation = lib.mkIf enabled {
      libvirtd.enable = true;
      docker = {
        enable = true;
        storageDriver = "btrfs";
      };
    };

    nixos.custom.features.register = feature_name;
  };
}
