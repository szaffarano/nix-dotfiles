{
  config,
  lib,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "sebas";
  home.homeDirectory = "/home/sebas";

  fonts.fontconfig.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    git
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

    comma # runs software without installing it

    # python
    python3
    poetry
    mypy
    black

    nodejs

    go

    # nix
    alejandra

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
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono" "JetBrainsMono"];})
    rofi
    foot
    clipman

    firefox
    chromium
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  services.gpg-agent = import gpg/gpg-agent.nix {};

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    mcfly = {
      enable = true;
      keyScheme = "vim";
      fuzzySearchFactor = 3;
    };
    starship = {
      enable = true;
    };
    tmux = import tmux/tmux.nix {pkgs = pkgs;};
    zsh = import zsh/zsh.nix {
      config = config;
      pkgs = pkgs;
      lib = lib;
    };
    git = import git/git.nix {pkgs = pkgs;};
    gpg = import gpg/gpg.nix {pkgs = pkgs;};
    neovim = import nvim/neovim.nix {
      lib = lib;
      pkgs = pkgs;
    };
    kitty = {
      enable = true;
      font = {
        name = "JetBrains Mono";
        size = 13;
      };
    };
    i3status-rust = import sway/i3status-rs.nix {};
  };

  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
  wayland.windowManager.sway = import sway/sway.nix {
    pkgs = pkgs;
    lib = lib;
    config = config;
  };
}
