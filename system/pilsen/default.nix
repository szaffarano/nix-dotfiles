{ inputs
, outputs
, lib
, config
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
    "fs.inotify.max_user_watches" = 300000;
    "fs.inotify.max_queued_events" = 300000;
  };

  services = {
    geoclue2.enable = true;
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };

    fwupd = {
      enable = lib.mkDefault true;
    };
    thermald = {
      enable = lib.mkDefault true;
    };
    upower.enable = true;

    # TODO: parameterize
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c52b", ATTR{power/wakeup}="enabled"
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="024f", ATTR{power/wakeup}="enabled"
    '';
  };

  hardware.bluetooth.enable = true;
  hardware.graphics.enable = true;
  nixos.custom.quietboot = true;
  programs = {
    dconf.enable = true;
    hyprland.enable = false;
    sway.enable = true;
  };
  services.greetd.enable = false;
  services.openssh.enable = true;
  sound.enable = true;

  nixos = {
    hostName = outputs.host.name;
    allowedUDPPorts = [
      22000
      21027
    ];
    allowedTCPPorts = [ 22000 ];
    disableWakeupLid = true;
    system = {
      inherit (outputs.user) authorizedKeys;
      user = outputs.user.name;
      hashedPasswordFile = config.sops.secrets.sebas-password.path;
    };
  };

  sops.secrets = {
    sebas-password = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };

  system.stateVersion = "23.05";

  #####################################################################################
  # Legacy configs: check where to move them
  #####################################################################################

  zramSwap.enable = true;
}
