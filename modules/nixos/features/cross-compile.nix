{ config
, lib
, ...
}:
let
  feature_name = "cross-compile";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  config = {
    boot.binfmt.emulatedSystems = lib.mkIf enabled [ "aarch64-linux" ];

    nixos.custom.features.register = feature_name;
  };
}
