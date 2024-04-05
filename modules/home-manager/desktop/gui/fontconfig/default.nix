{
  config,
  lib,
  theme,
  ...
}:
let
  cfg = config.desktop.gui.fontconfig;
in
with lib;
{
  # options.desktop.gui.fontconfig.enable = lib.mkEnableOption "fontconfig";
  options.desktop.gui.fontconfig.enable = mkEnableOption "fontconfig";

  config = lib.mkIf cfg.enable {
    # fontconfig.enable = true;
    fonts.fontconfig.enable = true;

    xdg.configFile."fontconfig/conf.d/99-fonts.conf".text =
      builtins.replaceStrings (builtins.attrNames theme.fonts) (builtins.attrValues theme.fonts)
        (builtins.readFile ./fonts.conf);
  };
}
