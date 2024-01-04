{ lib, ... }: {
  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
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
    disks = [ "/dev/sdb" ];
  };

  networking.useDHCP = lib.mkDefault true;

  # Often used values: “ondemand”, “powersave”, “performance”
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = true;

  nixpkgs.hostPlatform = "x86_64-linux";

  # Ref: "Cause #6" in https://wiki.archlinux.org/title/Network_configuration/Wireless#iwlwifi
  # Also, according to https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#d_3165_and_3168_support
  # device '3165' is not supported anymore (latest fw version -29.ucode)
  environment.etc."modprobe.d/iwlmvm.conf".text =
    "options iwlmvm power_scheme=1";
}
