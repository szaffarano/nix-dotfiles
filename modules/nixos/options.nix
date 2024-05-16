{ config, lib, ... }:
{
  options = with lib; {
    nixos.custom = {
      debug = mkEnableOption "debug NixOS";
      quietboot = mkEnableOption "quiet boot options";
      wol.phyname = mkOption {
        type = types.str;
        default = null;
      };
      power.lid =
        with types;
        mkOption {
          type = submodule {
            options = {
              name = mkOption {
                type = str;
                default = null;
              };
              action = mkOption {
                type = enum [
                  "enable"
                  "disable"
                ];
                default = "disable";
              };
            };
          };
        };
      features =
        with types;
        mkOption {
          type = submodule {
            options = {
              register = mkOption {
                type = lines;
                default = "";
              };
              enable = mkOption {
                type = listOf (enum (lib.splitString "\n" config.nixos.custom.features.register));
                default = [ ];
              };
            };
          };
        };
    };
  };
}
