{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.develop.rust;
in
  with lib; {
    options.develop.rust.enable = mkEnableOption "rust";

    config = with pkgs;
      lib.mkIf cfg.enable
      {
        home = let
          cargoHome = "${config.xdg.dataHome}/cargo";
        in {
          sessionPath = [
            "${cargoHome}/bin"
          ];
          sessionVariables = {
            CARGO_HOME = cargoHome;
          };
          packages = [
            bacon
            cargo
            cargo-bloat
            cargo-show-asm
            cargo-udeps
            clippy
            gcc
            rustc
            rustfmt
          ];
        };
      };
  }
