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
    ./spotify.nix
    ./net.nix
    ./pass.nix
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
        enableZshIntegration = true;
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

      fzf = let
        withHash = v: "#${v}";
      in {
        enable = true;
        enableZshIntegration = true;
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
          "--max-columns-preview"
          "--colors=line:style:bold"
          "--no-line-number"
          "--hidden"
        ];
      };

      yazi = {
        enable = true;
        enableZshIntegration = true;
      };

      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    home.packages = with pkgs; [
      arch
      bc
      boot-status
      bottom
      diffsitter
      eza
      fd
      httpie
      libqalculate
      ncdu
      ripgrep-all
      timer
    ];
  };
}
