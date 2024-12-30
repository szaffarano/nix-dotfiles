{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.audio;
in
  with lib; {
    imports = [];

    options.desktop.audio.enable = mkEnableOption "audio";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        pavucontrol
        playerctl
      ];
      services.playerctld = {
        enable = true;
      };
    };
  }
