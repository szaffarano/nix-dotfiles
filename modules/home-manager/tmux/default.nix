_:
{ config, lib, pkgs, ... }: {
  options.tmux.enable = lib.mkEnableOption "tmux";

  config =
    let
      catppuccin = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "tmux";
        rev = "4e48b09";
        sha256 = "sha256-bXEsxt4ozl3cAzV3ZyvbPsnmy0RAdpLxHwN82gvjLdU=";
      };
    in
    lib.mkIf config.tmux.enable {
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
          run-shell "${catppuccin}/catppuccin.tmux"

          set -g @catppuccin_flavour 'mocha'

          set-option -sa terminal-features ',xterm-256color:RGB'
          set -g status-position top

          bind C-a send-prefix -2
          bind C-c new-session
          bind Enter copy-mode

          bind C-h previous-window
          bind C-l next-window
        '';
      };
    };
}
