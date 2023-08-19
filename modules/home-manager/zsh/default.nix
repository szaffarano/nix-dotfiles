_:
{ config, lib, pkgs, ... }:
let extras = [ ./pyenv.zsh ./ocalm.zsh ./local.zsh ./rtx.zsh ./binds.zsh ];
in
{
  options.zsh.enable = lib.mkEnableOption "zsh";
  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      sessionVariables = { EDITOR = "nvim"; };
      enableCompletion = true;
      enableVteIntegration = true;
      defaultKeymap = "viins";

      zplug = {
        enable = true;
        plugins = [
          {
            name = "mafredri/zsh-async";
            tags = [ "defer:0" ];
          }
          {
            name = "lukechilds/zsh-nvm";
          }
          {
            name = "zsh-users/zsh-syntax-highlighting";
            tags = [ "defer:3" ];
          }
          { name = "zpm-zsh/clipboard"; }
          { name = "zsh-users/zsh-autosuggestions"; }
          {
            name = "wfxr/forgit";
            tags = [ "defer:1" ];
          }
          { name = "zsh-users/zsh-completions"; }
          {
            name = "hlissner/zsh-autopair";
            tags = [ "defer:2" ];
          }
          {
            name = "lib/completion";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "lib/grep";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "lib/history";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "lib/directories";
            tags = [ "from:oh-my-zsh" ];
          }
        ];
      };
      shellAliases = {
        ls = "ls --color";
        ll = "ls -l";

        # TODO: move to k8s-related module
        k = "kubectl";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      initExtra = lib.concatStringsSep "\n" (lib.lists.forEach extras (f:
        (builtins.readFile f)
      ));
    };
  };
}
