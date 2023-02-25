_:
{ config, lib, pkgs, ... }: {
  options.direnv.enable = lib.mkEnableOption "direnv";

  config = lib.mkIf config.direnv.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = false;
      enableFishIntegration = false;
      nix-direnv.enable = true;
    };
  };
}
