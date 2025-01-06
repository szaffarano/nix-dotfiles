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
      lib.mkIf cfg.enable {
        home = {
          sessionVariables.CARGO_HOME = "${config.xdg.dataHome}/cargo";
          packages = [
            bacon
            cargo
            clippy
            gcc
            rustc
            rustfmt
          ];
        };
      };
  }
