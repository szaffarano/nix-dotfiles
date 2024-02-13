{ config, lib, pkgs, ... }:
let cfg = config.develop;
in with lib; {
  imports = [ ./idea ./ocaml ];

  options.develop.enable = mkEnableOption "development tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pre-commit
      go
      nixfmt
      rustup
      hyperfine
    ];
  };
}
