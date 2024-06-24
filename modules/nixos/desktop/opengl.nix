{ config, lib, ... }:
{
  config = lib.mkIf config.hardware.opengl.enable {
    hardware = {
      graphics = {
        enable32Bit = lib.mkDefault true;
      };
    };
  };
}
