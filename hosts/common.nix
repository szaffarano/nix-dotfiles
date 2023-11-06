{ pkgs, ... }: {

  fontconfig.enable = true;

  ansible.enable = true;
  bat.enable = false;
  btop.enable = true;
  development = {
    enable = true;
    intellij-idea-pkg = pkgs.jetbrains.idea-ultimate;
  };
  direnv.enable = true;
  fzf.enable = true;
  keepassxc.enable = true;
  starship.enable = true;
  tmux.enable = true;
  zsh.enable = true;
  programs.jq.enable = true;
  programs.navi.enable = true;
  programs.nix-index.enable = true;
  ncspot.enable = true;

  home = {
    packages = with pkgs; [
      scc # analyze LOC and other code metrics
      sd # sed replacement
      bandwhich
      newsboat # rss feeds reader

      dig
      file
      fd
      icdiff
      du-dust
      tldr
      broot
      duf
      which
      gnumake
      comma
      gawk
      htop
      httpie
      openssl
      p7zip
      pandoc
      ripgrep
      sqlite
      tree
      unzip
      whois
      gopass
      pass
      yq
      nodePackages.json-diff
      usbutils
      lshw
      czkawka # duplicate files finder
      jless

      helix

      yubikey-personalization
      yubikey-personalization-gui

      ethtool
      solaar
      kubectl
      kubectx
      kubernetes-helm
      kustomize
      minikube
      kind
      argocd
      k9s
      kubeseal
      kubeconform

      shellcheck
      shfmt

      slack
      zoom-us

      vault
      aws-vault
      awscli2
      aws-iam-authenticator

      (
        google-cloud-sdk.withExtraComponents [
          google-cloud-sdk.components.gke-gcloud-auth-plugin
          google-cloud-sdk.components.pubsub-emulator
          google-cloud-sdk.components.cloud-firestore-emulator
        ]
      )

      rsync

      fontconfig
      font-awesome
      dejavu_fonts
      liberation_ttf
      ubuntu_font_family
      twemoji-color-font
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override {
        fonts = [ "FiraCode" "Hack" "DroidSansMono" "JetBrainsMono" "FantasqueSansMono" ];
      })
    ];
  };
  programs.zsh.profileExtra = ''
    export PATH="$PATH:$HOME/.nix-profile/bin"
    export PATH="$PATH:$HOME/.local/bin"
    export PATH="$PATH:$HOME/.bin"
    export PATH="$PATH:$HOME/.tfenv/bin"
    export AWS_VAULT_BACKEND="pass";
  '';
}
