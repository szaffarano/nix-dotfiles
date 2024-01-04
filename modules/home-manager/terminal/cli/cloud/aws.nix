{ config, lib, pkgs, ... }:
let cfg = config.terminal.cli.aws;
in with lib; {
  imports = [ ];

  options.terminal.cli.aws.enable = mkEnableOption "aws";

  config = mkIf cfg.enable {
    # TODO: awscli2 is broken
    home.packages = with pkgs; [ aws-vault aws-iam-authenticator ];
  };
}
