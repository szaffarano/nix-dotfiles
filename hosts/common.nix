{ config, pkgs, nixpkgs, lib, ... }: {

  fonts.fontconfig.enable = true;

  ansible.enable = true;
  bat.enable = true;
  btop.enable = true;
  development.enable = true;
  direnv.enable = true;
  fzf.enable = true;
  keepassxc.enable = true;
  neovim.enable = true;
  starship.enable = true;
  tmux.enable = true;
  zsh.enable = true;
  programs.jq.enable = true;
  programs.navi.enable = true;
  programs.nix-index.enable = true;
  ncspot.enable = true;

  home = {
    packages = with pkgs; [
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
      kubectx
      openssl
      p7zip
      pandoc
      ripgrep
      sqlite
      tree
      unzip
      whois
      pass

      slack
      zoom-us

      fontconfig
      font-awesome
      dejavu_fonts
      liberation_ttf
      ubuntu_font_family
      (nerdfonts.override {
        fonts = [ "FiraCode" "Hack" "DroidSansMono" "JetBrainsMono" ];
      })
    ];
  };
  programs.zsh.profileExtra = ''
    export PATH="$PATH:$HOME/.nix-profile/bin"
    export PATH="$PATH:$HOME/.asdf/shims";
    export AWS_VAULT_BACKEND="pass";
  '';
}
