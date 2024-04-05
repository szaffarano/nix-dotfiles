{ pkgs, lib, ... }:
{
  imports = [
    ./cloud
    ./direnv.nix
    ./git.nix
    ./gpg.nix
    ./ncspot.nix
    ./net.nix
    ./pass.nix
    ./ssh.nix
    ./starship.nix
    ./tmux.nix
    ./tools.nix
    ./yubikey.nix
  ];

  options.terminal.cli = { };

  config = {
    terminal.cli = {
      direnv.enable = lib.mkDefault true;
      ncspot.enable = lib.mkDefault true;
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
        flags = [ "--disable-up-arrow" ];
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

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    home.packages = with pkgs; [
      bc
      bottom
      comma
      diffsitter
      eza
      fd
      httpie
      libqalculate
      ncdu
      nixfmt-rfc-style
      ripgrep
      timer
    ];
  };
}
