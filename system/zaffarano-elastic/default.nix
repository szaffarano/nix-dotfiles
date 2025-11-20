{
  inputs,
  config,
  flakeRoot,
  pkgs,
  ...
}: let
  userName = "szaffarano";
  hostName = "zaffarano-elastic";
  email = "sebastian.zaffarano@elastic.co";

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
      "desktop"
      "cross-compile"
      "elastic-endpoint"
      "home-manager"
      "sway"
      "laptop"
      "nix-ld"
      "ollama"
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
    fprintd = {
      enable = true;
      tod = {
        enable = true;
        driver = pkgs.libfprint-2-tod1-broadcom;
      };
    };
    passSecretService = {
      enable = true;
    };
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      extraRules = [
        {
          name = "elastic-endpoin";
          nice = 10;
        }
        {
          name = "elastic-endpoint";
          nice = 10;
        }
        {
          name = "elastic-agent";
          nice = 10;
        }
      ];
    };
    greetd.enable = false;
    flatpak.enable = false;
  };
  networking = {
    inherit hostName;
    extraHosts = "127.0.0.1 bigquery broker elastic gcs pubsub redis zookeeper";
    wg-quick.interfaces.wg0 = {
      configFile = config.sops.secrets.wireguard.path;
      autostart = false;
    };
    firewall = {
      allowedTCPPorts = [9200 8200];
    };
  };

  sops.secrets = {
    wireguard = {
      format = "binary";
      sopsFile = ./secrets.wireguard;
    };
    szaffarano-password = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };

  system.stateVersion = "23.05";
}
