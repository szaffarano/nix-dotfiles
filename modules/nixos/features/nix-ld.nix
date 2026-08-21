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
        libsecret
        libunwind
        libusb1
        libuuid
        libX11
        libxcb
        libXcomposite
        libxcrypt-legacy
        libXcursor
        libXdamage
        libXext
        libXfixes
        libXi
        libxkbcommon
        libxml2
        libXrandr
        libXrender
        libXtst
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
        zlib
      ];
    };

    nixos.custom.features.register = feature_name;
  };
}
