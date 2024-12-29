{
  config,
  inputs,
  outputs,
  lib,
  ...
}: let
  feature_name = "home-manager";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  imports = [inputs.home-manager.nixosModules.home-manager];

  config = {
    home-manager = lib.mkIf enabled {
      backupFileExtension = "backup";
      extraSpecialArgs = {inherit inputs outputs;};
    };

    nixos.custom.features.register = feature_name;
  };
}
