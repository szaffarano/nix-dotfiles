{
  config,
  lib,
  ...
}: {
  options = with lib; {
    nixos.custom = {
      debug = mkEnableOption "debug NixOS";
      power = {
        wol.phyname = mkOption {
          type = types.str;
          default = null;
        };
        wakeup = {
          devices = with types;
            mkOption {
              type = listOf (submodule {
                options = {
                  idProduct = mkOption {type = str;};
                  idVendor = mkOption {type = str;};
                  action = mkOption {
                    type = enum [
                      "enabled"
                      "disabled"
                    ];
                    default = "enabled";
                  };
                };
              });
              default = [];
            };
          lid = with types;
            mkOption {
              type = submodule {
                options = {
                  name = mkOption {
                    type = str;
                    default = "";
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
              default = {};
            };
        };
      };
      features = with types;
        mkOption {
          type = submodule {
            options = {
              register = mkOption {
                type = lines;
                default = "";
              };
              enable = mkOption {
                type = listOf (enum (lib.splitString "\n" config.nixos.custom.features.register));
                default = [];
              };
            };
          };
        };
    };
  };
}
