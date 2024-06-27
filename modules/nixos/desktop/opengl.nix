{ config, lib, ... }:
{
  config = lib.mkIf config.hardware.graphics.enable {
    hardware = {
      graphics = {
        enable32Bit = lib.mkDefault true;
      };
    };
  };
}
