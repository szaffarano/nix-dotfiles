{ config, pkgs, nixpkgs, lib, ... }: {
  imports = [
    ../programs/development.nix
    ../programs/git
    ../programs/gpg
    ../programs/nvim
    ../programs/starship.nix
    ../programs/tmux.nix
    ../programs/zsh.nix
  ];

  home = {
    stateVersion = "22.11";
    packages = with pkgs; [
      (python3.withPackages (ps: with ps; [ pip flake8 black ipython mypy ]))
      poetry
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
      git-credential-keepassxc
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

  programs.firefox.enable = true;
  programs.chromium.enable = true;

  fonts.fontconfig.enable = true;
  programs.java.enable = true;
  programs.jq.enable = true;
  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-dash ];
    settings = {
      git_protocol = "https";
      prompt = "enabled";
      editor = "nvim";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
      };
    };
  };
  programs.bat = {
    enable = true;
    config = {
      map-syntax = [ "*.jenkinsfile:Groovy" "*.props:Java Properties" ];
      pager = "less -FR";
      theme = "Dracula";
    };
    themes = {
      dracula = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "dracula";
        repo = "sublime"; # Bat uses sublime syntax for its themes
        rev = "c5de15a0ad654a2c7d8f086ae67c2c77fda07c5f";
        sha256 = "sha256-m/MHz4phd3WR56I5jfi4hMXnFf4L4iXVpMFwtd0L0XE=";
      } + "/Dracula.tmTheme");
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [ "--height 40%" "--border" ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    nix-direnv.enable = true;
  };

}
