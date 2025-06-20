{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.terminal.cli.yubikey;
in
  with lib; {
    options.terminal.cli.yubikey.enable = mkEnableOption "yubikey";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        age-plugin-yubikey
        yubico-piv-tool
        yubikey-manager
        yubikey-personalization
        yubioath-flutter
      ];
    };
  }
