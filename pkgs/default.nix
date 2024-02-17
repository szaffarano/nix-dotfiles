{ pkgs ? import <nixpkgs> { } }:
let
  firefox-addons =
    import ./firefox-addons { inherit (pkgs) fetchurl stdenv lib; };
in
{
  configure-gtk = pkgs.callPackage ./configure-gtk { };
  lock-screen = pkgs.callPackage ./lock-screen { };
  toggle-sway-scratchpad = pkgs.callPackage ./toggle-sway-scratchpad { };
  wallpaper = pkgs.callPackage ./wallpaper { };
  wofi-power-menu = pkgs.callPackage ./wofi-power-menu { };
} // firefox-addons
