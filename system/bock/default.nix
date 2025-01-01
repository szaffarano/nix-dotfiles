{
  inputs,
  flakeRoot,
  ...
}: let
  userName = "sebas";
  hostName = "bock";

  sebas = import "${flakeRoot}/modules/nixos/users/sebas.nix" {
    inherit userName hostName;
  };
in {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix

    "${flakeRoot}/modules/nixos"

    sebas
  ];

  nixos.custom = {
    features.enable = [
      "home-manager"
      "nix-ld"
      "quietboot"
      "sensible"
    ];
  };

  networking = {inherit hostName;};

  sops.secrets = {
    sebas-password = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };

  system.stateVersion = "23.05";
}
