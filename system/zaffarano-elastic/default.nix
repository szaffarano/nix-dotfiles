{ inputs
, config
, flakeRoot
, ...
}:
let
  userName = "szaffarano";
  hostName = "zaffarano-elastic";
  email = "sebastian.zaffarano@elastic.co";

  szaffarano = import "${flakeRoot}/modules/nixos/users/sebas.nix" {
    inherit userName hostName email;
  };
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index

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
      "desktop"
      "elastic-endpoint"
      "laptop"
      "ollama"
      "quietboot"
      "sensible"
      "sway"
      "syncthing"
      "virtualisation"
    ];
  };
  services.greetd.enable = true;

  networking = {
    inherit hostName;
    extraHosts = "127.0.0.1 bigquery broker elastic gcs pubsub redis zookeeper";
    wg-quick.interfaces.wg0 = {
      configFile = config.sops.secrets.wireguard.path;
      autostart = false;
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
