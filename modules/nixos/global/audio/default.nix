{ config, lib, ... }:
{
  config = lib.mkIf config.sound.enable {
    security.rtkit.enable = lib.mkDefault true;
    services.pipewire = {
      enable = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
      alsa.enable = lib.mkDefault true;
    };
  };
}
