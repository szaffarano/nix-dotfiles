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
            (rust-bin.nightly.latest.default.override
              {
                extensions = ["rust-src"];
                targets = ["x86_64-pc-windows-gnu"];
              })
            bacon
            cargo-bloat
            cargo-udeps
            gcc
          ];
        };
      };
  }
