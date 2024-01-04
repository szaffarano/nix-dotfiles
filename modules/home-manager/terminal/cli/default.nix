{ pkgs, ... }: {
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
      direnv.enable = true;
      ncspot.enable = true;
      net.enable = true;
      pass.enable = true;
      starship.enable = true;
      tmux.enable = true;
      tools.enable = true;
      yubikey.enable = true;
    };

    programs = {
      jq.enable = true;
      bash.enable = true;

      bat = {
        enable = true;
        config.theme = "base16";
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
        defaultOptions = [ "--height 40%" "--border" ];
      };

      btop = {
        enable = true;
        settings = {
          theme_background = false;
          vim_keys = true;
          proc_tree = true;
        };
      };
    };

    home.packages = with pkgs; [
      comma
      bc
      bottom
      ncdu
      eza
      ripgrep
      fd
      httpie
      diffsitter
      timer
      nixfmt
    ];
  };
}
