{ config, lib, ... }:
let
  cfg = config.terminal.cli.starship;
in
with lib;
{

  options.terminal.cli.starship.enable = mkEnableOption "starship";

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;

      enableZshIntegration = true;
      enableBashIntegration = false;
      enableFishIntegration = false;

      settings = {
        cmd_duration.disabled = false;
        directory.truncation_length = 5;
        docker_context.disabled = false;
        git_branch.disabled = false;
        git_commit.disabled = false;
        git_metrics.disabled = true;
        git_state.disabled = false;
        git_status = {
          disabled = true;
          ignore_submodules = true;
          untracked = "";
        };
        java.disabled = true;
        kotlin.disabled = true;
        package.disabled = false;
        python.disabled = false;
        status.disabled = false;
      };
    };
  };
}
