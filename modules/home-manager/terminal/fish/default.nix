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
        autopair
        forgit
        z
      ];

      programs.fish = {
        enable = lib.mkDefault true;

        interactiveShellInit = ''
          fish_vi_key_bindings
          # TODO: workaround for https://github.com/nix-community/home-manager/issues/8178
          set -p fish_complete_path ${config.programs.fish.package}/share/fish/completions
        '';

        shellAliases = {
          nix-build-cached = "nh os switch --ask | cachix push szaffarano";
          nix-build = "nh os switch --ask";
          nix-cleanup = "nh clean all --keep-since 5d --keep 3";
          open = "xdg-open";
          pbcopy = "wl-copy";
        };

        shellInit = ''
          set -U fish_greeting

          set -gx FORGIT_FZF_DEFAULT_OPTS --exact --border --cycle --reverse --height '80%'
        '';
      };
    };
  }
