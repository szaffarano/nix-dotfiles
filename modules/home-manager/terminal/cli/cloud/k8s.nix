{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal.cli.k8s;
in
  with lib; {
    options.terminal.cli.k8s.enable = mkEnableOption "k8s";

    config = mkIf cfg.enable {
      programs.zsh = lib.mkIf config.programs.zsh.enable {
        shellAliases = {
          k = "kubectl";
        };
      };

      programs.fish = lib.mkIf config.programs.fish.enable {
        shellAliases = {
          k = "kubectl";
        };
      };

      home.packages = with pkgs; [
        argocd
        k9s
        kind
        kubeconform
        kubectl
        kubectx
        kubernetes-helm
        kubeseal
        kustomize
        minikube
      ];
    };
  }
