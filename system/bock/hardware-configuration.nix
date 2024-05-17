{ config
, lib
, modulesPath
, ...
}:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "sr_mod"
        "virtio_blk"
      ];
      kernelModules = [ ];
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
    extraModulePackages = [ ];
  };

  disko.devices = import ./disk-config.nix {
    inherit lib config;
    disks = [ "/dev/vda" ];
  };

  networking.useDHCP = lib.mkDefault true;

  # Often used values: “ondemand”, “powersave”, “performance”
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
