{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.develop.zig;
in
  with lib; {
    options.develop.zig.enable = mkEnableOption "zig";

    config = with pkgs;
      lib.mkIf cfg.enable {
        home = {
          packages = [zigpkgs.default];
        };
      };
  }
