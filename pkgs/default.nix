{
  pkgs ? import <nixpkgs> {},
  inputs,
  ...
}: let
  firefox-addons = import ./firefox-addons {inherit (pkgs) fetchurl stdenv lib;};
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  bazel_pkgs = import inputs.nixpkgs-bazel-5_1_1 {
    inherit (pkgs) system;
    config.permittedInsecurePackages = [
      "python-2.7.18.8" # needed by bazel 5.1.1
    ];
  };
  bazel_5_1_1 = with bazel_pkgs;
    callPackage ./bazel/bazel_5 {
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

  packages = {
    inherit bazel_5_1_1;
    arch = callPackage ./arch {};
    boot-status = callPackage ./boot-status {};
    check-elastic-endpoint = callPackage ./check-elastic-endpoint {};
    cleanup-merged-branches = callPackage ./cleanup-merged-branches {};
    cliphist-to-wofi = callPackage ./cliphist-to-wofi {};
    configure-gtk = callPackage ./configure-gtk {};
    flameshot-grim = callPackage ./flameshot {};
    get-keepass-entry = callPackage ./get-keepass-entry {};
    hackernews-tui = callPackage ./hackernews-tui {};
    lock-screen = callPackage ./lock-screen {};
    resurrect-hyprlock = callPackage ./resurrect-hyprlock {};
    sync-lid = callPackage ./sync-lid {};
    toggle-hyprland-scratchpad = callPackage ./toggle-hyprland-scratchpad {};
    toggle-sway-scratchpad = callPackage ./toggle-sway-scratchpad {};
    wallpaper = callPackage ./wallpaper {};
  };
in
  packages // firefox-addons
