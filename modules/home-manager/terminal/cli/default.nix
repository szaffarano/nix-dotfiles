{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./cloud
    ./direnv.nix
    ./git.nix
    ./gpg.nix
    ./jujutsu.nix
    ./net.nix
    ./pass.nix
    ./spotify.nix
    ./ssh.nix
    ./starship.nix
    ./tmux
    ./tools.nix
    ./yubikey.nix
  ];

  options.terminal.cli = {};

  config = {
    terminal.cli = {
      direnv.enable = lib.mkDefault true;
      spotify.enable = lib.mkDefault true;
      net.enable = lib.mkDefault true;
      pass.enable = lib.mkDefault true;
      starship.enable = lib.mkDefault true;
      tmux.enable = lib.mkDefault true;
      tools.enable = lib.mkDefault true;
      yubikey.enable = lib.mkDefault true;
    };

    programs = {
      jq.enable = true;
      bash.enable = true;

      atuin = {
        enable = true;
        enableZshIntegration = config.programs.zsh.enable;
        enableFishIntegration = config.programs.fish.enable;
        flags = ["--disable-up-arrow"];
        settings = {
          keymap_mode = "vim-insert";
        };
      };

      btop = {
        enable = true;
        settings = {
          theme_background = false;
          vim_keys = true;
          proc_tree = true;
        };
      };

      bat = {
        enable = true;
      };

      fd = {
        enable = true;
      };

      fzf = let
        withHash = v: "#${v}";
      in {
        enable = true;
        enableZshIntegration = config.programs.zsh.enable;
        enableFishIntegration = config.programs.fish.enable;
        changeDirWidgetCommand = "fd --type d";
        fileWidgetCommand = "fd --type f";

        colors = with config.colorScheme.palette; {
          "bg+" = withHash base01;
          bg = withHash base00;
          spinner = withHash base0C;
          hl = withHash base0D;
          fg = withHash base04;
          header = withHash base0D;
          info = withHash base0A;
          pointer = withHash base0C;
          marker = withHash base0C;
          "fg+" = withHash base06;
          prompt = withHash base0A;
          "hl+" = withHash base0D;
        };
      };

      ripgrep = {
        enable = true;
        arguments = [
          "--colors=line:style:bold"
          "--hidden"
          "--max-columns-preview"
          "--no-line-number"
          "--smart-case"
        ];
      };

      yazi = {
        enable = true;
        enableZshIntegration = config.programs.zsh.enable;
        enableFishIntegration = config.programs.fish.enable;
      };

      zoxide = {
        enable = true;
        enableZshIntegration = config.programs.zsh.enable;
        enableFishIntegration = config.programs.fish.enable;
      };
    };

    home.packages = with pkgs; [
      arch
      bc
      boot-status
      bottom
      diffsitter
      eza
      hackernews-tui
      httpie
      libqalculate
      lnav
      ncdu
      nh
      ripgrep-all
      timer
    ];
  };
}
