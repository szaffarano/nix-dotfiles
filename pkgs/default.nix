{ pkgs ? import <nixpkgs> { }
,
}:
let
  firefox-addons = import ./firefox-addons { inherit (pkgs) fetchurl stdenv lib; };
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = {
    boot-status = callPackage ./boot-status { };
    configure-gtk = callPackage ./configure-gtk { };
    flameshot-grim = callPackage ./flameshot { };
    lock-screen = callPackage ./lock-screen { };
    sync-lid = callPackage ./sync-lid { };
    toggle-hyprland-scratchpad = callPackage ./toggle-hyprland-scratchpad { };
    toggle-sway-scratchpad = callPackage ./toggle-sway-scratchpad { };
    wallpaper = callPackage ./wallpaper { };
  };
in
packages // firefox-addons
