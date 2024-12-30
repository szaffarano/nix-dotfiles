{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.hardware.graphics.enable {
    hardware = {
      graphics = {
        enable32Bit = lib.mkDefault (pkgs.hostPlatform == "x86_64-linux");
      };
    };
  };
}
