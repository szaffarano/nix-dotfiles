{ lib, pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./misc.nix
    ./hardware.nix
    ./locale.nix
    ./openssh.nix
    ./sops.nix
    ./system
  ];

  options.nixos = {
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the machine";
    };
  };

  config = {
    networking = {
      networkmanager = {
        enable = true;
        plugins = lib.mkForce [ ];
      };
    };

    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_zen;
      binfmt.emulatedSystems = [
        "aarch64-linux"
        "i686-linux"
      ];
      initrd.systemd.enable = true;
    };

    services = {
      udisks2.enable = true;
      envfs.enable = true;
    };

    environment.systemPackages = with pkgs; [
      linuxKernel.packages.linux_zen.perf
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
          alsa-lib
          at-spi2-core
          cairo
          cups
          curl
          dbus
          expat
          fontconfig
          fontconfig
          freetype
          fuse
          fuse3
          gdk-pixbuf
          glib
          gtk3
          harfbuzz
          fribidi
          icu
          libappindicator-gtk3
          libdrm
          libGL
          libnotify
          libpulseaudio
          libunwind
          libgpg-error
          e2fsprogs
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
          xorg.libxcb
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXi
          xorg.libXrandr
          xorg.libXrender
          xorg.libXtst
          zlib
        ];
      };

      zsh.enable = true;
    };
  };
}
