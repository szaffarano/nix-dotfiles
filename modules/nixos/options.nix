{ config, lib, ... }:
{
  options = with lib; {
    nixos.custom = {
      debug = mkEnableOption "debug NixOS";
      wol.phyname = mkOption {
        type = types.str;
        default = null;
      };
      power.wakeup.devices =
        with types;
        mkOption {
          type = listOf (submodule {
            options = {
              idProduct = mkOption { type = str; };
              idVendor = mkOption { type = str; };
              action = mkOption {
                type = enum [
                  "enabled"
                  "disabled"
                ];
                default = "enabled";
              };
            };
          });
        };
      power.wakeup.lid =
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
