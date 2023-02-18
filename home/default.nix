{ config, lib, pkgs, ... }: {
  imports = [ ./git ./gpg ./nvim ./sway ./tmux.nix ./zsh.nix ];

  home = {
    username = "sebas";
    homeDirectory = "/home/sebas";
    stateVersion = "22.11";
    packages = with pkgs; [
      #home-manager

      entr
      exa
      ripgrep
      fd
      htop
      glow
      icdiff
      zoxide
      du-dust
      tldr
      broot
      duf
      which
      gnumake
      unzip
      gh

      comma # runs software without installing it

      jetbrains.idea-community

      # python
      python3
      poetry
      mypy
      black

      nodejs

      go

      # nix
      nixfmt

      # rust
      rustc
      clippy
      cargo
      rustfmt
      rust-analyzer

      keepassxc
      git-credential-keepassxc

      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science es ]))

      # sway
      fontconfig
      font-awesome
      dejavu_fonts
      iosevka
      (nerdfonts.override {
        fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono" ];
      })
      swayidle
      wl-clipboard
      mako
      wlr-randr
      kanshi
      wtype
      rofi-bluetooth
      rofi-power-menu
      rofi-pulse-select

      playerctl

      firefox
      chromium
      speedcrunch
      anki
      calibre
      blueberry
      pulseaudioFull

      # screenshots
      grim
      slurp
      swappy
      sway-contrib.grimshot

      imagemagick
      pandoc
      pavucontrol
      qview
      tdesktop
      weechat
      xdg-utils
      zip
      copyq
      slack
    ];
  };

  fonts.fontconfig.enable = true;

  programs.java.enable = true;
  programs.jq.enable = true;
  programs.home-manager.enable = true;
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

  programs.ncspot = {
    enable = true;
    package = pkgs.ncspot.override { withALSA = false; };
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
