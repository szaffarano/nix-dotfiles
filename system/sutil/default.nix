{
  inputs,
  flakeRoot,
  pkgs,
  ...
}: let
  userName = "sebas";
  hostName = "sutil";
  email = "sebas@zaffarano.com.ar";

  szaffarano = import "${flakeRoot}/modules/nixos/users/sebas.nix" {
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

    szaffarano
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
      "calibre"
      "home-manager"
      "laptop"
      "nix-ld"
      "quietboot"
      "sensible"
      "syncthing"
      "virtualisation"
      "yubikey"
    ];
  };
  security.pam.services = {
    login.fprintAuth = true;
    sudo.fprintAuth = true;
  };
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "libfprint-2-tod1-broadcom"
    ];
  services = {
    passSecretService = {
      enable = true;
    };
    greetd.enable = false;
    flatpak.enable = false;
  };
  networking = {
    inherit hostName;
  };

  sops.secrets = {
    szaffarano-password = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };

  system.stateVersion = "23.05";
}
