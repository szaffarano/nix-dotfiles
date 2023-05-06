_:
{ config, lib, pkgs, theme, ... }: {
  options.fontconfig.enable = lib.mkEnableOption "fontconfig";

  config = lib.mkIf config.fontconfig.enable {
    fonts.fontconfig.enable = true;

    xdg.configFile."fontconfig/conf.d/99-fonts.conf".text = builtins.replaceStrings
      (builtins.attrNames theme.fonts)
      (builtins.attrValues theme.fonts)
      (builtins.readFile ./fonts.conf);
  };
}
