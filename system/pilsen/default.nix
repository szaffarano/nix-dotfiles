{
  inputs,
  flakeRoot,
  ...
}: let
  userName = "sebas";
  hostName = "pilsen";
  email = "sebas@zaffarano.com.ar";

  sebas = import "${flakeRoot}/modules/nixos/users/sebas.nix" {
    inherit userName hostName email;
  };
in {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix

    "${flakeRoot}/modules/nixos"

    sebas
  ];

  nixos.custom = {
    power = {
      wol.phyname = "phy0";
      wakeup = {
        devices = [
          {
            idVendor = "046d";
            idProduct = "c52b";
            action = "enabled";
          }
          {
            idVendor = "05ac";
            idProduct = "024f";
            action = "enabled";
          }
        ];
        lid = {
          name = "LID0";
          action = "disable";
        };
      };
    };
    features.enable = [
      "desktop"
      "home-manager"
      "laptop"
      "nix-ld"
      "ollama"
      "quietboot"
      "sensible"
      "sway"
      "syncthing"
      "virtualisation"
      "yubikey"
    ];
  };
  services.greetd.enable = false;

  networking = {inherit hostName;};

  sops.secrets = {
    sebas-password = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };

  system.stateVersion = "23.05";
}
