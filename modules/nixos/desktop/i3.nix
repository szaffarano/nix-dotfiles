{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.services.xserver.windowManager.i3.enable {
    security.pam.services = {
      i3lock = {};
    };
  };
}
