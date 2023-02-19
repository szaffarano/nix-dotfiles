_:
{ config, lib, pkgs, ... }: {
  options.fzf.enable = lib.mkEnableOption "NAME";

  config = lib.mkIf config.fzf.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [ "--height 40%" "--border" ];
    };
  };
}
