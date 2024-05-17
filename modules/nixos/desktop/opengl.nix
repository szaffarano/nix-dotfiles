{ config, lib, ... }:
{
  config = lib.mkIf config.hardware.opengl.enable {
    hardware = {
      opengl = {
        driSupport = lib.mkDefault true;
        driSupport32Bit = lib.mkDefault true;
      };
    };
  };
}
