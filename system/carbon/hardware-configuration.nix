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
        configurationLimit = 2;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };

    kernelModules = ["kvm-intel"];
  };

  disko.devices = import ./disk-config.nix {
    inherit lib config;
    disks = ["/dev/disk/by-id/nvme-SAMSUNG_MZVLC1T0HFLU-00BLL_S7SDNX0L310241"];
  };

  networking.useDHCP = lib.mkDefault true;

  hardware.cpu.intel = {
    updateMicrocode = true;
    npu.enable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
