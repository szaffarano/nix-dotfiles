{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.hyprland.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
