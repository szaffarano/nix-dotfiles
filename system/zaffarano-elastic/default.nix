{ inputs
, outputs
, lib
, config
, pkgs
, ...
}:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix
  ];

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

  networking.extraHosts = ''
    127.0.0.1 bigquery broker elastic gcs pubsub redis zookeeper
  '';

  services = {
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
  };

  services.greetd.enable = false;
  programs.hyprland.enable = true;
  programs.sway.enable = false;
  sound.enable = true;
  hardware.bluetooth.enable = true;
  services.openssh.enable = true;
  nixos.custom.quietboot = true;
  hardware.opengl.enable = true;
  programs.dconf.enable = true;

  nixos = {
    disableWakeupLid = true;
  };
  networking = {
    firewall = {
      allowedUDPPorts = [
        22000
        21027
      ];
      allowedTCPPorts = [ 22000 ];
    };
  };
  networking.wg-quick.interfaces.wg0 = {
    configFile = config.sops.secrets.wireguard.path;
    autostart = false;
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

  #####################################################################################
  # Legacy configs: check where to move them
  #####################################################################################

  zramSwap.enable = true;

  # TODO: parameterize
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c52b", ATTR{power/wakeup}="enabled"
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="024f", ATTR{power/wakeup}="enabled"
  '';
}
