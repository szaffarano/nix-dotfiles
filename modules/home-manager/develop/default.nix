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
      hyperfine

      # Rust (TODO: move to another place?)
      bacon
      cargo
      gcc
      rustc
      rustfmt
    ];

    # Rust (TODO: move to another place?)
    home.sessionVariables.CARGO_HOME = "${config.xdg.dataHome}/cargo";
  };
}
