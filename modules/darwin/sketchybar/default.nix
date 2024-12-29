{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.sketchybar;

  configHome = pkgs.writeTextFile {
    name = "sketchybarrc";
    text = cfg.config;
    destination = "/sketchybar/sketchybarrc";
    executable = true;
  };
in {
  meta.maintainers = [maintainers.azuwis or "azuwis"];

  options = with types; {
    services.sketchybar = {
      enable = mkOption {
        type = bool;
        default = false;
        description = "Whether to enable the sketchybar";
      };
      package = mkOption {
        type = path;
        description = "The sketchybar package to use.";
        default = pkgs.sketchybar;
      };
      pluginsDir = mkOption {
        type = path;
        description = "Directory containing sketchybar plugins";
        default = null;
      };
    };

    services.sketchybar.config = mkOption {
      type = str;
      default = "";
      example = literalExpression ''
        sketchybar --bar height=24
        sketchybar --update
        echo "sketchybar configuration loaded.."
      '';
      description = ''
        Content of configuration file. See <link xlink:href="https://felixkratz.github.io/SketchyBar/">documentation</link> and <link xlink:href="https://github.com/FelixKratz/SketchyBar/blob/master/sketchybarrc">example</link>.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    launchd.user.agents.sketchybar = {
      serviceConfig = {
        ProgramArguments = ["${cfg.package}/bin/sketchybar"];
        KeepAlive = true;
        RunAtLoad = true;
        EnvironmentVariables = {
          PATH = "${cfg.package}/bin:${cfg.pluginsDir}:${config.environment.systemPath}";
          XDG_CONFIG_HOME = mkIf (cfg.config != "") "${configHome}";
        };
      };
    };
  };
}
