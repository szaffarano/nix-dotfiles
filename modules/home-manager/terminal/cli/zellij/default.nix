{
  config,
  lib,
  ...
}: let
  cfg = config.terminal.cli.zellij;
in
  with lib; {
    options.terminal.cli.zellij.enable = mkEnableOption "zellij";

    config = mkIf cfg.enable {
      home.packages = [];

      programs.zellij = {
        enable = true;
      };
      programs.fish = mkIf config.programs.fish.enable {
        interactiveShellInit = ''
          ${lib.getExe config.programs.zellij.package} setup --generate-completion fish | source
        '';
      };

      xdg.configFile = {
        "zellij/config.kdl".source = ./config.kdl;
      };
    };
  }
