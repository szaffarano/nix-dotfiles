{pkgs ? import <nixpkgs> {}}: let
  firefox-addons = import ./firefox-addons {inherit (pkgs) fetchurl stdenv lib;};
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = with pkgs; rec {
    arch = callPackage ./arch {};
    bazel_5_1_1 = callPackage ./bazel/bazel_5 {
      inherit (darwin) cctools;
      inherit
        (darwin.apple_sdk.frameworks)
        CoreFoundation
        CoreServices
        Foundation
        ;
      buildJdk = jdk11_headless;
      runJdk = jdk11_headless;
      stdenv =
        if stdenv.cc.isClang
        then llvmPackages_12.stdenv
        else gcc12Stdenv;
      bazel_self = bazel_5_1_1;
    };
    boot-status = callPackage ./boot-status {};
    cliphist-to-wofi = callPackage ./cliphist-to-wofi {};
    configure-gtk = callPackage ./configure-gtk {};
    flameshot-grim = callPackage ./flameshot {};
    lock-screen = callPackage ./lock-screen {};
    sync-lid = callPackage ./sync-lid {};
    resurrect-hyprlock = callPackage ./resurrect-hyprlock {};
    toggle-hyprland-scratchpad = callPackage ./toggle-hyprland-scratchpad {};
    toggle-sway-scratchpad = callPackage ./toggle-sway-scratchpad {};
    wallpaper = callPackage ./wallpaper {};
    hackernews-tui = callPackage ./hackernews-tui {};
  };
in
  packages // firefox-addons
