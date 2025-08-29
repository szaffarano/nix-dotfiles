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
        "emacs/early-init.el".source = ./early-init.el;
        "emacs/init.el".source = ./init.el;
      };
    };
  }
