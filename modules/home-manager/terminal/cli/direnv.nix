{ config, lib, ... }:
let
  cfg = config.terminal.cli.direnv;
in
with lib;
{
  options.terminal.cli.direnv.enable = mkEnableOption "direnv";

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      nix-direnv.enable = true;
    };
  };
}
