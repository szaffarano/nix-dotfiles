{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.develop.idea;
in
  with lib; {
    imports = [];
    options.develop.idea = {
      enable = mkEnableOption "idea";
      ultimate = mkEnableOption "ultimate";
    };

    config = with pkgs; let
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
