_:
{ config, lib, pkgs, ... }:
let
  extras =
    [ ./pyenv.zsh ./ocalm.zsh ./local.zsh ./rtx.zsh ./binds.zsh ./breeze.zsh ];
in
{
  options.zsh.enable = lib.mkEnableOption "zsh";
  config = lib.mkIf config.zsh.enable {
    home.packages = [ pkgs.ruby ];
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
            name = "hlissner/zsh-autopair";
            tags = [ "defer:2" ];
          }
          {
            name = "lib/completion";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "lib/directories";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "lib/history";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "mafredri/zsh-async";
            tags = [ "defer:0" ];
          }
          {
            name = "scmbreeze/scm_breeze";
            tags = [ "defer:3" ];
          }
          {
            name = "wfxr/forgit";
            tags = [ "defer:1" ];
          }
          { name = "zpm-zsh/clipboard"; }
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/zsh-completions"; }
          {
            name = "zsh-users/zsh-syntax-highlighting";
            tags = [ "defer:3" ];
          }
        ];
      };

      shellAliases = {
        ls = "ls --color";

        # TODO: move to k8s-related module
        k = "kubectl";
      };

      history = {
        size = 50000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      initExtra = lib.concatStringsSep "\n"
        (lib.lists.forEach extras (f: (builtins.readFile f)));
    };
  };
}
