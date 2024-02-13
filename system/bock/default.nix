{ inputs, outputs, config, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel

    inputs.home-manager.nixosModules.home-manager

    ./hardware-configuration.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  nixos = {
    hostName = outputs.host.name;
    audio.enable = true;
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
