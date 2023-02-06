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
      fzf
      bat
      ripgrep
      fd
      jq
      htop
      tmux
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

      # sway
      fontconfig
      font-awesome
      dejavu_fonts
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

      ncspot
      playerctl

      firefox
      chromium
      keepassxc
      speedcrunch
      anki
      calibre
      gnome-themes-extra
      gnome.adwaita-icon-theme
      blueman
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

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    mcfly = {
      enable = true;
      keyScheme = "vim";
      fuzzySearchFactor = 5;
    };
    kitty = {
      enable = true;
      font = {
        name = "JetBrains Mono";
        size = 13;
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    nix-direnv.enable = true;
  };
}
