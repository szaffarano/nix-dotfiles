{ inputs, config, lib, pkgs, ... }:
let cfg = config.nixos;
in {
  imports = [
    ./audio
    ./bluetooth
    ./common
    ./hardware
    ./locale
    ./openssh
    ./quietboot
    ./sops.nix
    ./system
  ];

  options.nixos = {
    disableWakeupLid = lib.mkEnableOption "disableWakeupLid";
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the machine";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = "zaffarano.com.ar";
      description = "The domain of the machine";
    };
    allowedUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
      description = "The list of allowed UDP ports";
    };
  };

  config = {
    networking = {
      hostName = cfg.hostName;
      domain = cfg.domain;
      networkmanager.enable = true;
      firewall.allowedUDPPorts = cfg.allowedUDPPorts;
    };

    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_zen;
      binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" ];
      initrd.systemd.enable = true;
    };

    systemd.tmpfiles.rules = lib.optionals cfg.disableWakeupLid [
      #     Path                  Mode UID  GID  Age Argument
      "w    /proc/acpi/wakeup     -    -    -    -   LID0"
    ];

    environment.systemPackages = with pkgs; [
      curl
      git
      libinput
      neovim
      p7zip
      pciutils
      udisks
      unzip
      usbutils
      wget
      zip
    ];

    programs = {
      nix-index = {
        enableZshIntegration = false;
        enableBashIntegration = false;
      };
      nix-ld = {
        enable = true;
        package = inputs.nix-ld-rs.packages.${pkgs.hostPlatform.system}.nix-ld-rs;
      };

      zsh.enable = true;
    };
  };
}
