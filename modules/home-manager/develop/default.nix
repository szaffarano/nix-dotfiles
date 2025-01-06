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
      ./idea
      ./mise
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
        nixfmt-rfc-style
        hyperfine
      ];
    };
  }
