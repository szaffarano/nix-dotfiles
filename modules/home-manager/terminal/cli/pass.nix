{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal.cli.pass;
in
  with lib; {
    options.terminal.cli.pass.enable = mkEnableOption "pass";

    config = mkIf cfg.enable {
      programs.password-store = {
        enable = true;
        settings = {
          PASSWORD_STORE_DIR = "$HOME/.password-store";
        };
        package = pkgs.pass.withExtensions (p: [p.pass-otp]);
      };

      home.packages = with pkgs; [
        age
        gopass
        passage
      ];
    };
  }
