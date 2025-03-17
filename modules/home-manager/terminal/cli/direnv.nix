{
  config,
  lib,
  ...
}: let
  cfg = config.terminal.cli.direnv;
in
  with lib; {
    options.terminal.cli.direnv.enable = mkEnableOption "direnv";

    config = mkIf cfg.enable {
      programs.direnv = {
        enable = true;
        config = {
          global = {
            hide_env_diff = true;
            strict_env = true;
            warn_timeout = "30s";
          };
        };
        enableZshIntegration = config.programs.zsh.enable;
        enableBashIntegration = config.programs.bash.enable;
        nix-direnv.enable = true;
      };
    };
  }
