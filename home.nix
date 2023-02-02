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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.mcfly = {
    enable = true;
    keyScheme = "vim";
    fuzzySearchFactor = 3;
  };

  programs.starship = {
    enable = true;
  };

  services.gpg-agent = import gpg/gpg-agent.nix {};
  programs.tmux = import tmux/tmux.nix {pkgs = pkgs;};
  programs.zsh = import zsh/zsh.nix {
    config = config;
    pkgs = pkgs;
    lib = lib;
  };
  programs.git = import git/git.nix {pkgs = pkgs;};
  programs.gpg = import gpg/gpg.nix {pkgs = pkgs;};
  programs.neovim = import nvim/neovim.nix {
    lib = lib;
    pkgs = pkgs;
  };
  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      size = 13;
    };
  };
  programs.nix-index.enable = true;

  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        blocks = [
          {
            block = "disk_space";
            path = "/";
            alias = "/";
            info_type = "available";
            unit = "GB";
            interval = 60;
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "memory";
            display_type = "memory";
            format_mem = "{mem_used_percents}";
            format_swap = "{swap_used_percents}";
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "load";
            interval = 1;
            format = "{1m}";
          }
          {
            block = "time";
            interval = 60;
            format = "%a %d/%m %R";
          }
        ];
        settings = {
          theme = {
            name = "solarized-dark";
            overrides = {
              idle_bg = "#123456";
              idle_fg = "#abcdef";
            };
          };
        };
        icons = "awesome5";
        theme = "gruvbox-dark";
      };
    };
  };
}
