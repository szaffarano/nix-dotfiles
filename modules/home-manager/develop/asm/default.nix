{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.develop.asm;
in
  with lib; {
    options.develop.asm.enable = mkEnableOption "asm";

    config = with pkgs;
      lib.mkIf cfg.enable {
        home = {
          packages = [
            ghex
            nasm
          ];
        };
      };
  }
