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
        autopair
      ];

      programs.fish = {
        enable = lib.mkDefault true;
        shellInit = ''
          set -U fish_greeting

          set -gx EDITOR nvim
          set -gx SUDO_EDITOR nvim
          set -x FORGIT_FZF_DEFAULT_OPTS --exact --border --cycle --reverse --height '80%'
        '';

        shellAliases = {
          k = "kubectl";
          open = "xdg-open";
          pbcopy = "wl-copy";
          vim = "nvim";
          vi = "nvim";
          gs = "git status";
          gc = "git commit";
          cleanup-nix = "nh clean all --keep-since 5d --keep 3";
          build-nix = "nh os switch";
        };

        loginShellInit = lib.strings.optionalString config.wayland.windowManager.sway.enable ''
          set TTY1 (tty)
          [ "$TTY1" = "/dev/tty1" ] && exec \
            ${config.wayland.windowManager.sway.package}/bin/sway > ~/.cache/sway.log 2>~/.cache/sway.err.log
        '';

        interactiveShellInit = ''
          fish_vi_key_bindings
        '';
      };
    };
  }
