{ lib, config, ... }:
{
  options = with lib; {
    home.custom = {
      debug = mkEnableOption "debug home-manager";
      allowed-unfree-packages =
        with types;
        mkOption {
          type = listOf package;
          default = [ ];
          example = [ pkgs.vault-bin ];
          description = ''
            List of packages to configure the nixpkgs.config.allowUnfree option.
            Instead of having a "catch all" true or a centalized predicate, this
            option alows modules to include in this list the non-free packages they
            want to install.
          '';
        };
      permitted-insecure-packages =
        with types;
        mkOption {
          type = listOf str;
          default = [ ];
          example = [ "python-2.7.18.8" ];
          description = ''
            List of packages to configure the nixpkgs.config.permittedInsecurePackages option.
            Instead of having a "catch all" true or a centalized predicate, this
            option alows modules to include manage independent lists of packages.
          '';
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
                type = listOf (enum (lib.splitString "\n" config.home.custom.features.register));
                default = [ ];
              };
            };
          };
        };
    };
  };
}
