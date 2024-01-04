{ config, lib, pkgs, ... }:
let cfg = config.develop;
in with lib; {
  imports = [ (import ./idea) (import ./ocaml.nix) ];

  options.develop.enable = mkEnableOption "development tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # development
      pre-commit
      go
      nixfmt
      rustup
      hyperfine
    ];
  };
}
