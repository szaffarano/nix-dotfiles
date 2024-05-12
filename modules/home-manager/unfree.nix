{ lib, config, ... }:
let
  cfg = config.custom.unfree;
in
{
  options = with lib; {
    custom.unfree.packages =
      with types;
      mkOption {
        type = listOf package;
        default = [ ];
      };
  };
  config =
    let
      packageNames = map (p: lib.getName p) cfg.packages;
    in
    {
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        let
          packageName = lib.getName pkg;
          exists = builtins.elem packageName packageNames;
        in
        exists;
    };
}
