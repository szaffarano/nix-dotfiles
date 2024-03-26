{ config, lib, pkgs, ... }:
let cfg = config.terminal.cli.cloud;
in with lib; {
  imports = [ ./aws.nix ./gcp.nix ./k8s.nix ];

  options.terminal.cli.cloud.enable = mkEnableOption "cloud";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ vault-bin ];

    terminal.cli = {
      # until https://github.com/NixOS/nixpkgs/issues/298023 is fixed
      aws.enable = false;
      gcp.enable = true;
      k8s.enable = true;
    };
  };
}
