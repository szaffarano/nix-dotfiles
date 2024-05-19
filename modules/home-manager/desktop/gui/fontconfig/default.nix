{ config, lib, ... }:
let
  inherit (config) fontProfiles;
  cfg = config.desktop.gui.fontconfig;

  fonts = {
    f-serif = fontProfiles.serif.name;
    f-sans-serif = fontProfiles.regular.name;
    f-mono = fontProfiles.monospace.name;
    f-emoji = fontProfiles.emoji.name;
  };
in
with lib;
{
  options.desktop.gui.fontconfig.enable = mkEnableOption "fontconfig";

  config = lib.mkIf cfg.enable {
    # fontconfig.enable = true;
    fonts.fontconfig.enable = true;

    xdg.configFile."fontconfig/conf.d/99-fonts.conf".text =
      builtins.replaceStrings (builtins.attrNames fonts) (builtins.attrValues fonts)
        (builtins.readFile ./fonts.conf);
  };
}
