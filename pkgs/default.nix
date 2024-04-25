{ pkgs ? import <nixpkgs> { }
,
}:
let
  firefox-addons = import ./firefox-addons { inherit (pkgs) fetchurl stdenv lib; };
in
{
  configure-gtk = pkgs.callPackage ./configure-gtk { };
  lock-screen = pkgs.callPackage ./lock-screen { };
  toggle-sway-scratchpad = pkgs.callPackage ./toggle-sway-scratchpad { };
  toggle-hyprland-scratchpad = pkgs.callPackage ./toggle-hyprland-scratchpad { };
  wallpaper = pkgs.callPackage ./wallpaper { };
  disable-lid = pkgs.callPackage ./disable-lid { };
}
  // firefox-addons
