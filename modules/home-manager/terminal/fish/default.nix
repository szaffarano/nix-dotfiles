{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal.fish;

  # 26.11.0 breaks git autocompletion
  forgitPrev = pkgs.fishPlugins.forgit.overrideAttrs (_: {
    version = "26.10.0";
    src = pkgs.fetchFromGitHub {
      owner = "wfxr";
      repo = "forgit";
      tag = "26.10.0";
      hash = "sha256-Kno14XqXwtG0zWVjrikoXf7eIXo3pj7YbSoQOYUcAI4=";
    };
  });
in
  with lib; {
    options.terminal.fish = {
      enable = mkEnableOption "fish";
    };

    config = mkIf cfg.enable {
      home.packages = [
        pkgs.fishPlugins.autopair
        pkgs.fishPlugins.z
        forgitPrev
      ];

      programs.fish = {
        enable = lib.mkDefault true;

        interactiveShellInit = ''
          fish_vi_key_bindings
        '';

        shellAliases = {
          nixb = "nh os switch --ask";
          nixc = "nh clean all --keep-since 5d --keep 3";
          open = "xdg-open";
          pbcopy = "wl-copy";
        };

        functions = {
          prstate = {
            description = "Show PR state, mergedAt, mergedBy (current branch if no number)";
            body = ''
              gh pr view $argv --json state,mergedAt,mergedBy \
                --jq '"state:    \(.state)\nmergedAt: \(.mergedAt // "-")\nmergedBy: \(.mergedBy.login // "-")"'
            '';
          };
        };

        shellInit = ''
          set -U fish_greeting

          set -gx FORGIT_FZF_DEFAULT_OPTS --exact --border --cycle --reverse --height '80%'
        '';
      };
    };
  }
