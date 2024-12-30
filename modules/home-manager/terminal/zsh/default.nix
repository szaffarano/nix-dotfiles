{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal.zsh;
in
  with lib; {
    options.terminal.zsh = {
      enable = mkEnableOption "zsh";
      extras = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Extra features to enable";
      };
    };

    config = mkIf cfg.enable {
      home.packages = with pkgs; [ruby];
      programs.zsh = {
        enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        enableVteIntegration = true;
        defaultKeymap = "viins";

        zplug = {
          enable = true;
          plugins = [
            {
              name = "hlissner/zsh-autopair";
              tags = ["defer:2"];
            }
            {
              name = "lib/completion";
              tags = ["from:oh-my-zsh"];
            }
            {
              name = "lib/directories";
              tags = ["from:oh-my-zsh"];
            }
            {
              name = "lib/history";
              tags = ["from:oh-my-zsh"];
            }
            {
              name = "mafredri/zsh-async";
              tags = ["defer:0"];
            }
            {
              name = "scmbreeze/scm_breeze";
              tags = ["defer:2"];
            }
            {
              name = "wfxr/forgit";
              tags = ["defer:3"];
            }
            {name = "zpm-zsh/clipboard";}
            {name = "zsh-users/zsh-autosuggestions";}
            {name = "zsh-users/zsh-completions";}
            {
              name = "zsh-users/zsh-syntax-highlighting";
              tags = ["defer:3"];
            }
          ];
        };

        history = {
          size = 50000;
          path = "${config.xdg.dataHome}/zsh/history";
        };

        initExtra = lib.concatStringsSep "\n" (
          lib.lists.forEach cfg.extras (
            f:
              lib.concatStringsSep "\n" [
                "# ${f}"
                (builtins.readFile ./${f}.zsh)
                "# /${f}"
              ]
          )
        );
      };
    };
  }
