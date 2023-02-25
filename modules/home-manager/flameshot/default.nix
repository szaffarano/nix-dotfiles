_:
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.flameshot;
  iniFormat = pkgs.formats.ini { };
  iniFile = iniFormat.generate "flameshot.ini" cfg.settings;
in
{
  options.flameshot.enable = mkEnableOption "flameshot";
  options.flameshot.settings = mkOption {
    type = iniFormat.type;
    default = { };
    example = {
      General = {
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
    description = ''
      Configuration to use for Flameshot. See
      <link xlink:href="https://github.com/flameshot-org/flameshot/blob/master/flameshot.example.ini"/>
      for available options.
    '';
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.flameshot ];

    xdg.configFile = mkIf (cfg.settings != { }) {
      "flameshot/flameshot.ini".source = iniFile;
    };
  };
}
