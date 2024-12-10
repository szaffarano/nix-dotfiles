{ pkgs, ... }:
{
  home = {
    custom.features.enable = [ ];
    packages = [ pkgs.gcc ];
  };

  programs.nix-index.enable = true;

  terminal.zsh = {
    enable = true;
    extras = [
      "local"
    ];
  };

  programs.mise.enable = true;
}
