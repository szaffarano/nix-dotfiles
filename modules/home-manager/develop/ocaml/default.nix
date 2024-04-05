{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.develop.ocaml;
in
with lib;
{
  options.develop.ocaml.enable = mkEnableOption "ocaml";

  config =
    with pkgs;
    lib.mkIf cfg.enable {
      home = {
        packages = [
          opam
          gcc
        ];
      };
    };
}
