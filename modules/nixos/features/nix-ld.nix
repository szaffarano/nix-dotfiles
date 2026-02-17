{
  config,
  lib,
  pkgs,
  ...
}: let
  feature_name = "nix-ld";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  config = {
    programs.nix-ld = lib.mkIf enabled {
      enable = true;
      libraries = with pkgs; [
        alsa-lib
        at-spi2-core
        cairo
        cups
        curl
        dbus
        e2fsprogs
        expat
        fontconfig
        freetype
        fribidi
        fuse
        fuse3
        gdk-pixbuf
        glib
        gtk3
        harfbuzz
        icu
        libappindicator-gtk3
        libdrm
        libgcc.lib
        libGL
        libgpg-error
        libnotify
        libpulseaudio
        libunwind
        libusb1
        libuuid
        libxcrypt-legacy
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
        wayland-protocols
        libX11
        libxcb
        libXcomposite
        libXcursor
        libXdamage
        libXext
        libXfixes
        libXi
        libXrandr
        libXrender
        libXtst
        zlib
      ];
    };

    nixos.custom.features.register = feature_name;
  };
}
