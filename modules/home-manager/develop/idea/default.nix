{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.develop.idea;
  jetbrains_pkgs = import inputs.nixpkgs-jetbrains {
    inherit (pkgs) system;
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "idea-ultimate"
      ];
  };
in
  with lib; {
    imports = [];
    options.develop.idea = {
      enable = mkEnableOption "idea";
      ultimate = mkEnableOption "ultimate";
    };

    config = with jetbrains_pkgs; let
      package =
        if cfg.ultimate
        then jetbrains.idea-ultimate
        else jetbrains.idea-community;
    in
      lib.mkIf cfg.enable {
        home = {
          custom.allowed-unfree-packages = with pkgs; lib.optionals cfg.ultimate [jetbrains.idea-ultimate];
          packages = [package];
          file.".ideavimrc" = {
            source = ./ideavimrc;
          };
        };
      };
  }
