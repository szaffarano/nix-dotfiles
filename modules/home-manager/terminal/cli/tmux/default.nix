{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.terminal.cli.tmux;
  theme = config.scheme { templateRepo = ./.; };
in
with lib;
{
  options.terminal.cli.tmux.enable = mkEnableOption "tmux";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      prefix = "C-a";
      escapeTime = 1;
      baseIndex = 1;
      keyMode = "vi";

      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
        tmuxPlugins.sensible
        tmuxPlugins.prefix-highlight
        tmuxPlugins.pain-control
        tmuxPlugins.yank
      ];

      extraConfig = ''
        set-option -sa terminal-features ',xterm-256color:RGB'
        set -g status-position top

        bind C-a send-prefix -2
        bind C-c new-session
        bind Enter copy-mode

        bind C-h previous-window
        bind C-l next-window

        set -g focus-events on

        set -g status-interval 1

        source-file ${theme}
      '';
    };
  };
}
