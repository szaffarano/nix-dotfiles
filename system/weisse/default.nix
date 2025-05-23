{
  inputs,
  flakeRoot,
  ...
}: let
  userName = "sebas";
  hostName = "weisse";

  sebas = import "${flakeRoot}/modules/nixos/users/sebas.nix" {
    inherit userName hostName;
  };
in {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    inputs.home-manager.nixosModules.home-manager

    ./audio.nix
    ./hardware-configuration.nix
    ./keyboard.nix

    "${flakeRoot}/modules/nixos"

    sebas
  ];

  # boot.kernelPackages =  inputs.nixpkgs-kernel.legacyPackages.${pkgs.hostPlatform.system}.linuxKernel.packages.linux_zen;

  security.rtkit.enable = true;
  systemd.tpm2.enable = false;
  boot.initrd.systemd.tpm2.enable = false;
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
    greetd.enable = false;
    # TODO move to module?
    printing.enable = true;
  };

  nixos.custom = {
    power = {
      wol.phyname = "phy0";
      wakeup = {
        lid = {
          name = "LID0";
          action = "disable";
        };
      };
    };
    features.enable = [
      "calibre"
      "desktop"
      "home-manager"
      "laptop"
      "nix-ld"
      "quietboot"
      "sensible"
      "sway"
      "syncthing"
      "yubikey"
    ];
  };

  networking = {inherit hostName;};

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
