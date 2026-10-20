{pkgs ? import <nixpkgs> {}, ...}: let
  firefox-addons = import ./firefox-addons {inherit (pkgs) fetchurl stdenv lib;};
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);

  packages = {
    arch = callPackage ./arch {};
    boot-status = callPackage ./boot-status {};
    check-elastic-endpoint = callPackage ./check-elastic-endpoint {};
    cleanup-merged-branches = callPackage ./cleanup-merged-branches {};
    cliphist-to-wofi = callPackage ./cliphist-to-wofi {};
    configure-gtk = callPackage ./configure-gtk {};
    flameshot-grim = callPackage ./flameshot {};
    get-keepass-entry = callPackage ./get-keepass-entry {};
    hackernews-tui = callPackage ./hackernews-tui {};
    live-nvim = callPackage ./live-nvim {};
    lock-screen = callPackage ./lock-screen {};
    resurrect-hyprlock = callPackage ./resurrect-hyprlock {};
    sync-lid = callPackage ./sync-lid {};
    toggle-hyprland-scratchpad = callPackage ./toggle-hyprland-scratchpad {};
    toggle-sway-scratchpad = callPackage ./toggle-sway-scratchpad {};
    wallpaper = callPackage ./wallpaper {};
  };
in
  packages // firefox-addons
