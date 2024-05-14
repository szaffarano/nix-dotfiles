{ inputs
, lib
, localLib
, config
, pkgs
, ...
}:
{

  imports = [
    inputs.disko.nixosModules.disko
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index

    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  users = {
    mutableUsers = false;
    users.szaffarano = {
      hashedPasswordFile = config.sops.secrets.szaffarano-password.path;
      extraGroups =
        [
          "wheel"
          "networkmanager"
          "video"
          "audio"
        ]
        ++ (lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ])
        ++ (lib.optionals config.virtualisation.docker.enable [ "docker" ]);

      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGM8VrSbHicyD5mOAivseLz0khnvj4sDqkfnFyipqXCg cardno:19_255_309"
      ];
    };
  };

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
        ../../modules/home-manager
        ../../users/szaffarano/zaffarano-elastic.nix
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

  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 512000;
    "fs.inotify.max_queued_events" = 512000;
  };

  systemd.services = {
    ElasticEndpoint = {
      wantedBy = [ "multi-user.target" ];
      description = "ElasticEndpoint";
      unitConfig = {
        StartLimitInterval = 600;
        ConditionFileIsExecutable = "/opt/Elastic/Endpoint/elastic-endpoint";
      };
      serviceConfig = {
        ExecStart = "/opt/Elastic/Endpoint/elastic-endpoint run";
        Restart = "on-failure";
        RestartSec = 15;
        StartLimitBurst = 16;
      };
    };

    elastic-agent = {
      wantedBy = [ "multi-user.target" ];
      description = "Elastic Agent is a unified agent to observe, monitor and protect your system.";
      unitConfig = {
        StartLimitInterval = 5;
        ConditionFileIsExecutable = "/opt/Elastic/Agent/elastic-agent";
      };
      serviceConfig = {
        ExecStart = "/opt/Elastic/Agent/elastic-agent";
        WorkingDirectory = "/opt/Elastic/Agent";
        Restart = "always";
        RestartSec = 120;
        KillMode = "process";
        StartLimitBurst = 10;
      };
    };

    "wol@phy0" = {
      wantedBy = [ "multi-user.target" ];
      description = "Wake-on-LAN for phy0";
      unitConfig = {
        Requires = "network.target";
        After = "network.target";
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.iw}/bin/iw phy0 wowlan enable magic-packet";
      };
    };
  };

  services = {
    greetd.enable = false;
    openssh.enable = true;
    geoclue2.enable = true;
    upower.enable = true;
    tailscale = {
      enable = true;
    };
    fwupd = {
      enable = lib.mkDefault true;
    };
    thermald = {
      enable = lib.mkDefault true;
    };
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c52b", ATTR{power/wakeup}="enabled"
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="024f", ATTR{power/wakeup}="enabled"
    '';
  };

  hardware = {
    bluetooth.enable = true;
    opengl.enable = true;
  };

  nixos.custom.quietboot = true;

  programs = {
    dconf.enable = true;
    hyprland.enable = true;
    sway.enable = false;
  };

  sound.enable = true;

  nixos = {
    disableWakeupLid = true;
  };

  networking = {
    domain = lib.mkDefault "zaffarano.com.ar";
    hostName = "zaffarano-elastic";
    extraHosts = ''
      127.0.0.1 bigquery broker elastic gcs pubsub redis zookeeper
    '';

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

  powerManagement.powertop.enable = true;

  environment.systemPackages = with pkgs; [ powertop ];

  zramSwap.enable = true;
}
