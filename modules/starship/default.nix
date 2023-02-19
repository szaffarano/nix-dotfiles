_:
{ config, lib, pkgs, ... }: {
  options.starship.enable = lib.mkEnableOption "starship";

  config = lib.mkIf config.starship.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      settings = {
        cmd_duration.disabled = false;
        docker_context.disabled = false;
        java.disabled = true;
        kotlin.disabled = true;
        git_branch.disabled = false;
        git_commit.disabled = false;
        git_metrics.disabled = false;
        git_state.disabled = false;
        git_status = {
          disabled = false;
          ignore_submodules = true;
          untracked = "";
        };
        package.disabled = false;
        python.disabled = false;
        status.disabled = false;
      };
    };
  };
}
