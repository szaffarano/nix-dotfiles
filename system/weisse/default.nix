{ inputs, outputs, config, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix
  ];

  nixos = {
    hostName = outputs.host.name;
    allowedUDPPorts = [ 22000 21027 ];
    allowedTCPPorts = [ 22000 ];
    audio.enable = true;
    disableWakeupLid = false;
    quietboot.enable = true;
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
  };

  system.stateVersion = "23.05";

  zramSwap.enable = true;
}
