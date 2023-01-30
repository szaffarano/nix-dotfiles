{config, pkgs}:
{
    enable = true;
    enableSyntaxHighlighting = true;
    sessionVariables = {
      EDITOR = "nvim";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "mafredri/zsh-async"; tags = [ defer:0 ]; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:3 ]; }
        { name = "zpm-zsh/clipboard"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "wfxr/forgit"; tags = [ defer:1 ]; }
        { name = "zsh-users/zsh-completions"; }
        { name = "hlissner/zsh-autopair"; tags = [ defer:2 ]; }
        { name = "lib/completion"; tags = [ from:oh-my-zsh ]; }
        { name = "lib/grep"; tags = [ from:oh-my-zsh ]; }
        { name = "lib/history"; tags = [ from:oh-my-zsh ]; }
        { name = "lib/directories"; tags = [ from:oh-my-zsh ]; }
      ];
    };
    shellAliases = {
      update = "sudo nixos-rebuild switch";
      ls="ls --color";
      ll="ls -l";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  }
