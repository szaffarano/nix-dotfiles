{ inputs, outputs, config, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix
  ];

  services.geoclue2.enable = true;
  services.pcscd.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };

  nixos = {
    hostName = outputs.host.name;
    allowedUDPPorts = [ 22000 21027 ];
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
      hashedPasswordFile = config.sops.secrets.sebas-password.path;
      authorizedKeys = outputs.user.authorizedKeys;
    };
  };

  sops.secrets = {
    sebas-password = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };

    luks-password = {
      sopsFile = ./secrets.yaml;
    };
  };

  system.stateVersion = "23.05";

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
