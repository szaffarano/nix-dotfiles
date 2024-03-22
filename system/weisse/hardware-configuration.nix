{ config, lib, ... }: {
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ "kvm-intel" ];
    };

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 2;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };

    kernelModules = [ "kvm-intel" ];
  };

  disko.devices = import ./disk-config.nix {
    inherit lib;
    disks = [ "/dev/disk/by-id/mmc-TY2964_0x325f92cb" ];
    config = config;
  };

  networking.useDHCP = lib.mkDefault true;

  # Often used values: “ondemand”, “powersave”, “performance”
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
