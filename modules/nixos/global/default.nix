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
    allowedTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
      description = "The list of allowed TCP ports";
    };
  };

  config = {
    networking = {
      hostName = cfg.hostName;
      domain = cfg.domain;
      networkmanager.enable = true;
      firewall.allowedUDPPorts = cfg.allowedUDPPorts;
      firewall.allowedTCPPorts = cfg.allowedTCPPorts;
    };

    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_zen;
      binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" ];
      initrd.systemd.enable = true;
    };

    systemd.services.disable-LID0 = lib.mkIf cfg.disableWakeupLid {
      wantedBy = [ "multi-user.target" ];
      description = "Disable wakeup on opening LID0";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.disable-lid}/bin/disable-lid";
      };
    };

    services.udisks2.enable = true;

    environment.systemPackages = with pkgs; [
      curl
      e2fsprogs
      git
      gptfdisk
      libinput
      mkpasswd
      neovim
      p7zip
      pciutils
      rclone
      restic
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
        libraries = with pkgs; [
          ncurses
          cairo
          cups
          curl
          dbus
          expat
          fontconfig
          freetype
          fuse3
          gdk-pixbuf
          glib
          gtk3
          icu
          libappindicator-gtk3
          libdrm
          libnotify
          libpulseaudio
          libunwind
          libusb1
          libuuid
          libxkbcommon
          libxml2
          mesa
          nspr
          nss
          openssl
          pango
          pipewire
          stdenv.cc.cc
          systemd
          vulkan-loader
          xorg.libXext
          xorg.libX11
          xorg.libXrender
          xorg.libXtst
          xorg.libXi
          zlib
        ];
      };

      zsh.enable = true;
    };
  };
}
