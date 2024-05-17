{ config
, lib
, pkgs
, ...
}:
let
  feature_name = "syncthing";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  config = {
    networking = lib.mkIf enabled {
      firewall = {
        allowedUDPPorts = [
          22000
          21027
        ];
        allowedTCPPorts = [ 22000 ];
      };
    };

    environment.systemPackages = with pkgs; lib.optionals enabled [ powertop ];
    nixos.custom.features.register = feature_name;
  };
}
