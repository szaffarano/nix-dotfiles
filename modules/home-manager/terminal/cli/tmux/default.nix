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
      home.packages = with pkgs; [tmuxp];
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

        extraConfig = with config.colorScheme.palette; ''
          set-option -sa terminal-features ',xterm-256color:RGB'
          set -g status-position top

          bind C-a send-prefix -2
          bind C-c new-session
          bind Enter copy-mode

          bind C-h previous-window
          bind C-l next-window

          set -g focus-events on

          set -g status-interval 1

          # theme
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
