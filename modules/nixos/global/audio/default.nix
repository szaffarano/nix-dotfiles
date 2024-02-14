{ config, lib, ... }:
let cfg = config.nixos.audio;
in {
  options.nixos.audio.enable = lib.mkEnableOption "audio";

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    sound.enable = true;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
  };
}
