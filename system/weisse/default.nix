{ inputs
, flakeRoot
, pkgs
, ...
}:
let
  userName = "sebas";
  hostName = "weisse";

  sebas = import "${flakeRoot}/modules/nixos/users/sebas.nix" { inherit userName hostName; };
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index

    ./audio.nix
    ./hardware-configuration.nix
    ./keyboard.nix

    "${flakeRoot}/modules/nixos"

    sebas
  ];

  # boot.kernelPackages =  inputs.nixpkgs-kernel.legacyPackages.${pkgs.hostPlatform.system}.linuxKernel.packages.linux_zen;

  security.rtkit.enable = true;
  sound.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  nixos.custom = {
    features.enable = [
      "audio"
      "desktop"
      "sway"
      "laptop"
      "quietboot"
      "sensible"
      "syncthing"
    ];
  };
  services.greetd.enable = true;

  networking = {
    inherit hostName;
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
}
