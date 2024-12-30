{
  inputs,
  outputs,
  config,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko

    ./hardware-configuration.nix
  ];

  nixos.custom.quietboot = true;

  nixos = {
    hostName = outputs.host.name;
    disableWakeupLid = false;
    system = {
      inherit (outputs.user) authorizedKeys;
      user = outputs.user.name;
      hashedPasswordFile = config.sops.secrets.sebas-password.path;
    };
  };

  virtualisation = {
    libvirtd.enable = false;
    docker = {
      enable = true;
      storageDriver = "btrfs";
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
