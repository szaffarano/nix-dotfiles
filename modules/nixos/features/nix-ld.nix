{ config
, lib
, pkgs
, ...
}:
let
  feature_name = "nix-ld";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
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

    nixos.custom.features.register = feature_name;
  };
}
