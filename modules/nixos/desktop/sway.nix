{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.sway.enable {
    security.pam.services = {
      swaylock = {};
    };
  };
}
