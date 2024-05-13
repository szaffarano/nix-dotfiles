{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixos;
in
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./misc.nix
    ./hardware.nix
    ./locale.nix
    ./openssh.nix
    ./quietboot.nix
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
      inherit (cfg) domain hostName;
      networkmanager = {
        enable = true;
        plugins = lib.mkForce [ ];
      };
      firewall.allowedUDPPorts = cfg.allowedUDPPorts;
      firewall.allowedTCPPorts = cfg.allowedTCPPorts;
    };

    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_zen;
      binfmt.emulatedSystems = [
        "aarch64-linux"
        "i686-linux"
      ];
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
      cachix
      curl
      e2fsprogs
      git
      gptfdisk
      libinput
      mkpasswd
      neovim-unwrapped
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
      nix-index-database.comma.enable = true;
      nix-ld = {
        enable = true;
        package = pkgs.inputs.nix-ld-rs.nix-ld-rs;
        libraries = with pkgs; [
          cairo
          cups
          curl
          dbus
          expat
          fontconfig
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
          libxkbcommon
          libxml2
          mesa
          ncurses
          nspr
          nss
          openssl
          pango
          pipewire
          stdenv.cc.cc
          systemd
          vulkan-loader
          wayland
          xorg.libX11
          xorg.libXext
          xorg.libXi
          xorg.libXrender
          xorg.libXtst
          zlib
        ];
      };

      zsh.enable = true;
    };
  };
}
