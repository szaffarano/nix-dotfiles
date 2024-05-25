{ config, ... }:
let
  feature_name = "ollama";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  services.ollama = {
    enable = enabled;
  };

  nixos.custom.features.register = feature_name;
}
