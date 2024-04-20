{
  inputs,
  outputs,
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

    ./audio.nix
    ./hardware-configuration.nix
    ./keyboard.nix
  ];

  nixos = {
    hostName = outputs.host.name;
    allowedUDPPorts = [
      22000
      21027
    ];
    allowedTCPPorts = [ 22000 ];
    audio.enable = true;
    bluetooth.enable = true;
    disableWakeupLid = false;
    quietboot.enable = true;
    system = {
      user = outputs.user.name;
      hashedPasswordFile = config.sops.secrets.sebas-password.path;
      authorizedKeys = outputs.user.authorizedKeys;
    };
    desktop = {
      enable = true;
      sway.enable = true;
      greeter.enable = false;
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
