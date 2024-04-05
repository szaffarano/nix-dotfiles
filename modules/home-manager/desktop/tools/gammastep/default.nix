{ config, lib, ... }:
let
  cfg = config.desktop.tools.gammastep;
in
with lib;
{

  options.desktop.tools.gammastep.enable = mkEnableOption "gammastep";

  config = mkIf cfg.enable {

    services.gammastep = {
      enable = true;
      provider = "geoclue2";
      temperature = {
        day = 6000;
        night = 4600;
      };
      settings = {
        general.adjustment-method = "wayland";
      };
    };
  };
}
