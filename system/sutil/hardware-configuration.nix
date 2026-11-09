{
  config,
  lib,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
      kernelModules = [];
      luks.devices = {
        nixos.crypttabExtraOpts = ["tries=3"];
        swap.crypttabExtraOpts = ["tries=3"];
      };
    };

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };

    kernelModules = ["kvm-intel"];
  };

  disko.devices = import ./disk-config.nix {
    inherit lib config;
    disks = ["/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B76863BE669"];
  };

  networking.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  environment.etc."modprobe.d/iwlmvm.conf".text = "options iwlmvm power_scheme=1";
}
