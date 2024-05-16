{ inputs
, localLib
, config
, flakeRoot
, ...
}:
let
  szaffarano = import "${flakeRoot}/modules/nixos/users/sebas.nix" { username = "szaffarano"; };
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

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit localLib;
    };
    users.szaffarano = {
      imports = [
        inputs.nix-colors.homeManagerModule
        inputs.nix-index-database.hmModules.nix-index
        inputs.nur.nixosModules.nur

        "${flakeRoot}/modules/home-manager"
        "${flakeRoot}/users/szaffarano/zaffarano-elastic.nix"
      ];
      config = {
        git = {
          user = {
            name = "Sebastián Zaffarano";
          };
        };
      };
    };
  };

  services = {
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c52b", ATTR{power/wakeup}="enabled"
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="024f", ATTR{power/wakeup}="enabled"
    '';
  };

  nixos.custom = {
    quietboot = true;
    wol.phyname = "phy0";
    power.lid = {
      name = "LID0";
      action = "disable";
    };
    features.enable = [
      "audio"
      "desktop"
      "elastic-endpoint"
      "hyprland"
      "laptop"
      "quietboot"
      "sensible"
      "virtualisation"
    ];
  };

  networking = {
    domain = "zaffarano.com.ar";
    hostName = "zaffarano-elastic";
    extraHosts = "127.0.0.1 bigquery broker elastic gcs pubsub redis zookeeper";
    firewall = {
      allowedUDPPorts = [
        22000
        21027
      ];
      allowedTCPPorts = [ 22000 ];
    };
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
