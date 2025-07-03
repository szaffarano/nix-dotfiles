{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.develop.nodejs;
in
  with lib; {
    options.develop.nodejs.enable = mkEnableOption "nodejs";

    config = with pkgs;
      lib.mkIf cfg.enable {
        home = {
          packages = [
            nodejs_24
          ];
        };
      };
  }
