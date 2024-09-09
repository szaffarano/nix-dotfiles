{ pkgs
, config
, lib
, ...
}:
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
    ./tmux
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
        changeDirWidgetCommand = "fd --type d";
        fileWidgetCommand = "fd --type f";

        colors = with config.scheme.withHashtag; {
          "bg+" = base01;
          bg = base00;
          spinner = base0C;
          hl = base0D;
          fg = base04;
          header = base0D;
          info = base0A;
          pointer = base0C;
          marker = base0C;
          "fg+" = base06;
          prompt = base0A;
          "hl+" = base0D;
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
      nixfmt-rfc-style
      timer
    ];
  };
}
