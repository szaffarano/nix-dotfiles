{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal.cli.cloud;
in
  with lib; {
    imports = [
      ./aws.nix
      ./gcp.nix
      ./k8s.nix
    ];

    options.terminal.cli.cloud.enable = mkEnableOption "cloud";

    config = mkIf cfg.enable {
      home = {
        custom.allowed-unfree-packages = with pkgs; [vault-bin];
        packages = with pkgs; [vault-bin];
      };

      terminal.cli = {
        aws.enable = true;
        # FIXME: broken package
        gcp.enable = false;
        k8s.enable = true;
      };
    };
  }
