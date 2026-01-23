{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.develop;
in
  with lib; {
    imports = [
      ./asm
      ./emacs
      ./idea
      ./mise
      ./nodejs
      ./ocaml
      ./python
      ./rust
      ./zig
    ];

    options.develop.enable = mkEnableOption "development tools";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        pre-commit
        go
        nixfmt
        hyperfine
      ];
    };
  }
