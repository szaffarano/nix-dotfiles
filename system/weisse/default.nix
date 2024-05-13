{ inputs
, outputs
, config
, ...
}:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager

    ./audio.nix
    ./hardware-configuration.nix
    ./keyboard.nix
  ];

  services = {
    tailscale = {
      enable = true;
    };
  };

  services.greetd.enable = false;
  programs.hyprland.enable = true;
  programs.sway.enable = false;
  sound.enable = true;
  hardware.bluetooth.enable = true;
  services.openssh.enable = true;
  nixos.custom.quietboot = true;

  nixos = {
    hostName = outputs.host.name;
    allowedUDPPorts = [
      22000
      21027
    ];
    allowedTCPPorts = [ 22000 ];
    disableWakeupLid = false;
    system = {
      inherit (outputs.user) authorizedKeys;
      user = outputs.user.name;
      hashedPasswordFile = config.sops.secrets.sebas-password.path;
    };

    desktop = {
      enable = true;
    };
  };

  # TODO move to module?
  services.printing.enable = true;

  boot.kernelParams = [
    "nosgx"
    "i915.fastboot=1"
    "mem_sleep_default=deep"
  ];

  sops.secrets = {
    sebas-password = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };

  system.stateVersion = "23.05";

  zramSwap.enable = true;
}
