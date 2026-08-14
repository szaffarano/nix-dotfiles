{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal.cli.aws;
in
  with lib; {
    imports = [];

    options.terminal.cli.aws.enable = mkEnableOption "aws";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        awscli2
        aws-iam-authenticator
        aws-vault
        ssm-session-manager-plugin
      ];
    };
  }
