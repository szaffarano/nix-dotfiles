{ pkgs }:
{
  enable = true;
  prefix = "C-a";
  escapeTime = 1;
  baseIndex = 1;
  keyMode = "vi";

  plugins = with pkgs; [
    tmuxPlugins.better-mouse-mode
    tmuxPlugins.sensible
    tmuxPlugins.power-theme
    tmuxPlugins.prefix-highlight
    tmuxPlugins.pain-control
    tmuxPlugins.yank
  ];

  extraConfig = ''
    set-option -sa terminal-overrides ',xterm-255color:RGB'
    set -g status-position top

    bind C-a send-prefix -2
    bind C-c new-session
    bind Enter copy-mode

    bind C-h previous-window
    bind C-l next-window
  '';

}
