{
  config,
  lib,
  ...
}: let
  cfg = config.terminal.cli.jujutsu;
in
  with lib; {
    options.terminal.cli.jujutsu.enable = mkEnableOption "jujutsu";
    config = mkIf cfg.enable {
      programs.jujutsu = {
        enable = true;
        ediff = false;
      };
    };
  }
