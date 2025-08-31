{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.develop.emacs;
in
  with lib; {
    options.develop.emacs.enable = mkEnableOption "emacs";

    config = lib.mkIf cfg.enable {
      programs.emacs = {
        enable = true;
        package = pkgs.emacs-nox;
      };
      xdg.configFile = {
        "emacs/config.org".source = ./config.org;
        "emacs/init.el".source = ./init.el;
      };
    };
  }
