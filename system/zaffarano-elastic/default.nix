{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix
  ];

  services.geoclue2.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };

  systemd.services.ElasticEndpoint = {
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

  systemd.services.elastic-agent = {
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

  systemd.services."wol@phy0" = {
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

  networking.extraHosts = ''
    127.0.0.1 bigquery broker elastic gcs pubsub redis zookeeper
  '';

  services = {
    fwupd = {
      enable = lib.mkDefault true;
    };
    thermald = {
      enable = lib.mkDefault true;
    };
  };

  nixos = {
    hostName = outputs.host.name;
    allowedUDPPorts = [
      22000
      21027
    ];
    allowedTCPPorts = [ 22000 ];
    audio.enable = true;
    bluetooth.enable = true;
    disableWakeupLid = true;
    quietboot.enable = true;
    desktop = {
      enable = true;
      sway.enable = true;
      greeter.enable = false;
    };
    system = {
      user = outputs.user.name;
      hashedPasswordFile = config.sops.secrets.szaffarano-password.path;
      authorizedKeys = outputs.user.authorizedKeys;
    };
  };

  sops.secrets = {
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

  services.upower.enable = true;

  # TODO: parameterize
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c52b", ATTR{power/wakeup}="enabled"
    ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="024f", ATTR{power/wakeup}="enabled"
  '';
}
