{ config
, inputs
, lib
, ...
}:
let
  cfg = config.desktop.tools.zathura;
in
with lib;
{

  options.desktop.tools.zathura.enable = mkEnableOption "zathura";

  config = mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      extraConfig = builtins.readFile (config.scheme inputs.base16-zathura);

      options = {
        selection-clipboard = "clipboard";
        font = "${config.fontProfiles.regular.family} 12";
        recolor = true;
      };
    };
  };
}
