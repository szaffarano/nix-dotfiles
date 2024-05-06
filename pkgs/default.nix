{ pkgs ? import <nixpkgs> { }
,
}:
let
  firefox-addons = import ./firefox-addons { inherit (pkgs) fetchurl stdenv lib; };
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = {
    configure-gtk = callPackage ./configure-gtk { };
    lock-screen = callPackage ./lock-screen { };
    toggle-sway-scratchpad = callPackage ./toggle-sway-scratchpad { };
    toggle-hyprland-scratchpad = callPackage ./toggle-hyprland-scratchpad { };
    wallpaper = callPackage ./wallpaper { };
    disable-lid = callPackage ./disable-lid { };
  };
in
packages // firefox-addons
