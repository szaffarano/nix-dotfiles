{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.sound;
in
  with lib; {
    options.sound.enable = mkEnableOption "sound";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [alsa-utils];
      services.fluidsynth = {
        enable = true;
        soundService = "pipewire-pulse";
        extraOptions = ["-g 2"];
      };
    };
  }
