{ config, pkgs, nixpkgs, lib, ... }: {

  fonts.fontconfig.enable = true;

  ansible.enable = true;
  bat.enable = true;
  btop.enable = true;
  development.enable = true;
  direnv.enable = true;
  firefox.enable = true;
  fzf.enable = true;
  git.enable = true;
  gpg.enable = true;
  neovim.enable = true;
  starship.enable = true;
  tmux.enable = true;
  zsh.enable = true;
  programs.chromium.enable = true;
  programs.jq.enable = true;
  programs.navi.enable = true;
  programs.nix-index.enable = true;

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
      keepassxc
      unzip
      whois

      fontconfig
      font-awesome
      dejavu_fonts
      iosevka
      (nerdfonts.override {
        fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ];
      })
    ];
  };
}
