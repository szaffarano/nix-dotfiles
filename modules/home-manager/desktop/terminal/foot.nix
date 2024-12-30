{
  config,
  lib,
  ...
}: let
  inherit (config.fontProfiles) monospace;
  cfg = config.desktop.terminal.foot;
in
  with lib; {
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
          colors = with config.colorScheme.palette; {
            foreground = base05;
            background = base00;
            regular0 = base00;
            regular1 = base08;
            regular2 = base0B;
            regular3 = base0A;
            regular4 = base0D;
            regular5 = base0E;
            regular6 = base0C;
            regular7 = base05;
            bright0 = base03;
            bright1 = base08;
            bright2 = base0B;
            bright3 = base0A;
            bright4 = base0D;
            bright5 = base0E;
            bright6 = base0C;
            bright7 = base07;
          };
        };
      };
    };
  }
