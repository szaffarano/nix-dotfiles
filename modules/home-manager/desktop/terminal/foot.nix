{ config, lib, ... }:
let
  inherit (config.fontProfiles) monospace;
  cfg = config.desktop.terminal.foot;
in
with lib;
{
  options.desktop.terminal.foot.enable = mkEnableOption "foot";

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        TERMINAL = "foot";
      };
    };

    programs.foot = lib.mkIf cfg.enable {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          font = "${monospace.name}:size=${builtins.toString (monospace.sizeAsInt * 0.9)}";
          selection-target = "both";
        };
        colors = with config.scheme; {
          foreground = "${base05-hex}";
          background = "${base00-hex}";
          regular0 = "${base00-hex}";
          regular1 = "${base08-hex}";
          regular2 = "${base0B-hex}";
          regular3 = "${base0A-hex}";
          regular4 = "${base0D-hex}";
          regular5 = "${base0E-hex}";
          regular6 = "${base0C-hex}";
          regular7 = "${base05-hex}";
          bright0 = "${base03-hex}";
          bright1 = "${base08-hex}";
          bright2 = "${base0B-hex}";
          bright3 = "${base0A-hex}";
          bright4 = "${base0D-hex}";
          bright5 = "${base0E-hex}";
          bright6 = "${base0C-hex}";
          bright7 = "${base07-hex}";
        };
      };
    };
  };
}
