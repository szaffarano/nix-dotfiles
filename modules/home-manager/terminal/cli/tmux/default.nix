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
          # https://github.com/tmux-plugins/tmux-pain-control
          tmuxPlugins.pain-control

          # https://github.com/tmux-plugins/tmux-yank
          tmuxPlugins.yank
        ];

        extraConfig = with config.colorScheme.palette; ''
          # Allow programs in the pane to bypass tmux using a terminal escape sequen. Required for image preview.
          set -gq allow-passthrough on

          # ============================================= #
          # Terminal settings                             #
          # --------------------------------------------- #
          set -g default-terminal ''${TERM}
          set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
          set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
          set -g focus-events on

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
          if-shell '[ "$TINTED_TMUX_OPTION_ACTIVE" = "1" ] || [ "$BASE16_TMUX_OPTION_ACTIVE" = "1" ]' {
            set-window-option -g window-active-style "fg=#${base05},bg=#${base00}"
            set-window-option -g window-style "fg=#${base05},bg=#${base01}"
          }
          if-shell '[ "$TINTED_TMUX_OPTION_STATUSBAR" = "1" ] || [ "$BASE16_TMUX_OPTION_STATUSBAR" = "1" ]' {
            set-option -g status "on"
            set-option -g status-justify "left"
            set-option -g status-left "#[fg=#${base05},bg=#${base03}] #S #[fg=#${base03},bg=#${base01},nobold,noitalics,nounderscore]"
            set-option -g status-left-length "80"
            set-option -g status-left-style none
            set-option -g status-right "#[fg=#${base02},bg=#${base01} nobold, nounderscore, noitalics]#[fg=#${base04},bg=#${base02}] %Y-%m-%d  %H:%M #[fg=#${base05},bg=#${base02},nobold,noitalics,nounderscore]#[fg=#${base01},bg=#${base05}] #h "
            set-option -g status-right-length "80"
            set-option -g status-right-style none
            set-window-option -g window-status-current-format "#[fg=#${base01},bg=#${base0A},nobold,noitalics,nounderscore]#[fg=#${base02},bg=#${base0A}] #I #[fg=#${base02},bg=#${base0A},bold] #W#{?window_zoomed_flag,*Z,} #[fg=#${base0A},bg=#${base01},nobold,noitalics,nounderscore]"
            set-window-option -g window-status-format "#[fg=#${base01},bg=#${base02},noitalics]#[fg=#${base06},bg=#${base02}] #I #[fg=#${base06},bg=#${base02}] #W #[fg=#${base02},bg=#${base01},noitalics]"
            set-window-option -g window-status-separator ""
          }
        '';
      };
    };
  }
