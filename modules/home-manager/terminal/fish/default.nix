{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal.fish;
in
  with lib; {
    options.terminal.fish = {
      enable = mkEnableOption "fish";
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs.fishPlugins; [
        z
        forgit
      ];

      programs.fish = {
        enable = lib.mkDefault true;

        interactiveShellInit = ''
          fish_vi_key_bindings
        '';

        shellAliases = {
          gc = "git commit";
          gps = "git push";
          gs = "git status";
          k = "kubectl";
          nix-build = "nh os switch";
          nix-cleanup = "nh clean all --keep-since 5d --keep 3";
          open = "xdg-open";
          pbcopy = "wl-copy";
          vim = "nvim";
          vi = "nvim";
        };

        shellInit = ''
          set -U fish_greeting

          set -gx EDITOR nvim
          set -gx SUDO_EDITOR nvim
          set -gx FORGIT_FZF_DEFAULT_OPTS --exact --border --cycle --reverse --height '80%'
        '';
      };
    };
  }
