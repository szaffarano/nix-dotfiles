{
  config,
  lib,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "rtsx_pci_sdmmc"
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
      kernelModules = ["kvm-intel"];
    };

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 2;
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

  # Often used values: “ondemand”, “powersave”, “performance”
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = true;

  nixpkgs.hostPlatform = "x86_64-linux";
  environment.etc."modprobe.d/iwlmvm.conf".text = "options iwlmvm power_scheme=1";
}
