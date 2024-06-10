{ config, lib, ... }:
let
  feature_name = "audio";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  sound.enable = lib.mkDefault enabled;

  nixos.custom.features.register = feature_name;
}
