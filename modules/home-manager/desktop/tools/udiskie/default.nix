{ config
, lib
, ...
}:
let
  cfg = config.desktop.tools.udiskie;
in
with lib;
{
  options.desktop.tools.udiskie.enable = mkEnableOption "udiskie";

  config = mkIf cfg.enable {
    services.udiskie = {
      enable = true;
      automount = lib.mkDefault false;
      tray = lib.mkDefault "auto";
    };
  };
}
