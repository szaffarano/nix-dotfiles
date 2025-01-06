{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.develop.python;
in
  with lib; {
    options.develop.python.enable = mkEnableOption "python";

    config = with pkgs;
      lib.mkIf cfg.enable {
        home = {
          packages = [
            uv
          ];
        };
      };
  }
