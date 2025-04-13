{
  config,
  lib,
  ...
}: let
  feature_name = "calibre";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  config = {
    networking = lib.mkIf enabled {
      firewall = {
        allowedUDPPorts = [
          54982
          48123
          39001
          44044
          59678
        ];
        allowedTCPPorts = [9090];
      };
    };
    nixos.custom.features.register = feature_name;
  };
}
