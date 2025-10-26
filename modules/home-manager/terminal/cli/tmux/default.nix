{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal.cli.tmux;
in
  with lib; {
    options.terminal.cli.tmux.enable = mkEnableOption "tmux";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [twm];

      xdg.configFile = {
        "twm/twm.yaml".source = ./twm.yaml;
        "twm/twm.schema.json".source = ./twm.schema.json;
      };

      programs.zsh = {
        sessionVariables = {
          TWM_DEFAULT = "random";
        };
      };
      programs.tmux = {
        enable = true;
        baseIndex = 1;
        clock24 = true;
        escapeTime = 1;
        historyLimit = 500000;
        keyMode = "vi";
        prefix = "C-a";
        secureSocket = true;
        sensibleOnTop = true;

        plugins = with pkgs; [
          tmuxPlugins.pain-control # https://github.com/tmux-plugins/tmux-pain-control
          tmuxPlugins.yank # https://github.com/tmux-plugins/tmux-yank
          tmuxPlugins.tmux-toggle-popup # https://github.com/loichyan/tmux-toggle-popup
        ];

        extraConfig = with config.colorScheme.palette; ''
          # Allow programs in the pane to bypass tmux using a terminal escape sequen. Required for image preview.
          set -gq allow-passthrough on

          # ============================================= #
          # Terminal settings                             #
          # --------------------------------------------- #
          set -g default-terminal "tmux-256color"
          set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
          set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
          set -g focus-events on
          set-option -a terminal-features 'foot:RGB'

          # ============================================= #
          # Bindings                                      #
          # --------------------------------------------- #
          ## misc bindings
          bind C-c new-session
          bind C-h previous-window
          bind C-l next-window
          bind Enter copy-mode
          bind & kill-window
          bind x kill-pane
          bind r run-shell "tmux resize-window -A" # redraw window

          ## twm bindings
          bind e run-shell "tmux switch -t $TWM_DEFAULT"
          bind f run-shell "tmux neww twm"
          bind F run-shell "tmux neww twm -l"
          bind g run-shell "tmux neww twm -g"
          bind o display-popup -E "twm"
          bind O display-popup -E "twm -l"
          bind S choose-session
          bind s run-shell "tmux neww twm -e"

          # popups
          bind C-t run "#{@popup-toggle} -Ed'#{pane_current_path}' -w75% -h75%"
          bind C-g run "#{@popup-toggle} -Ed'#{pane_current_path}' -w90% -h90% --name=lazygit lazygit"
          bind C-o run "#{@popup-toggle} -Ed'#{pane_current_path}' -w75% -h75% --name=opencode mise exec opencode -- opencode"
          bind C-d run "#{@popup-toggle} -Ed'#{pane_current_path}' -w75% -h75% --name=claude mise exec node@latest -- claude"
          bind C-j run "#{@popup-toggle} -Ed'#{pane_current_path}' -w75% -h75% --name=gemini mise exec node@latest -- gemini"

          # ============================================= #
          # Theme                                         #
          # --------------------------------------------- #
          set -g status-position top
          set-option -g status-style "fg=#${base04},bg=#${base01}"
          set-window-option -g window-status-style "fg=#${base04},bg=#${base01}"
          set-window-option -g window-status-current-style "fg=#${base0A},bg=#${base01}"
          set-option -g pane-border-style "fg=#${base01}"
          set-option -g pane-active-border-style "fg=#${base04}"
          set-option -g message-style "fg=#${base06},bg=#${base02}"
          set-option -g display-panes-active-colour "#${base04}"
          set-option -g display-panes-colour "#${base01}"
          set-window-option -g clock-mode-colour "#${base0D}"
          set-window-option -g mode-style "fg=#${base04},bg=#${base02}"
          set-window-option -g window-status-bell-style "fg=#${base00},bg=#${base08}"
          set-window-option -g window-status-activity-style "fg=#${base05},bg=#${base01}"
          set-option -g message-command-style "fg=#${base06},bg=#${base02}"
        '';
      };
    };
  }
