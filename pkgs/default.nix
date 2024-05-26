{ pkgs ? import <nixpkgs> { }
,
}:
let
  firefox-addons = import ./firefox-addons { inherit (pkgs) fetchurl stdenv lib; };
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = {
    configure-gtk = callPackage ./configure-gtk { };
    lock-screen = callPackage ./lock-screen { };
    flameshot-grim = callPackage ./flameshot { };
    toggle-sway-scratchpad = callPackage ./toggle-sway-scratchpad { };
    toggle-hyprland-scratchpad = callPackage ./toggle-hyprland-scratchpad { };
    wallpaper = callPackage ./wallpaper { };
    sync-lid = callPackage ./sync-lid { };
  };
in
packages // firefox-addons
