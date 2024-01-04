{ config, lib, pkgs, ... }:
let cfg = config.terminal.cli.cloud;
in with lib; {
  imports = [ ./aws.nix ./gcp.nix ./k8s.nix ];

  options.terminal.cli.cloud.enable = mkEnableOption "cloud";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ vault ];

    terminal.cli = {
      aws.enable = true;
      gcp.enable = true;
      k8s.enable = true;
    };
  };
}
