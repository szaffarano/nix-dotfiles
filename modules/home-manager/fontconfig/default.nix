_:
{ config, lib, pkgs, ... }: {
  options.fontconfig.enable = lib.mkEnableOption "fontconfig";

  config = lib.mkIf config.fontconfig.enable {
    fonts.fontconfig.enable = true;

    xdg.configFile."fontconfig/conf.d/99-fonts.conf".source = ./fonts.conf;
  };
}
