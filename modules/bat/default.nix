_:
{ config, lib, pkgs, ... }: {
  options.bat.enable = lib.mkEnableOption "bat";

  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
      config = {
        map-syntax = [ "*.jenkinsfile:Groovy" "*.props:Java Properties" ];
        pager = "less -FR";
        theme = "Dracula";
      };
      themes = {
        dracula = builtins.readFile (pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "sublime"; # Bat uses sublime syntax for its themes
          rev = "c5de15a0ad654a2c7d8f086ae67c2c77fda07c5f";
          sha256 = "sha256-m/MHz4phd3WR56I5jfi4hMXnFf4L4iXVpMFwtd0L0XE=";
        } + "/Dracula.tmTheme");
      };
    };
  };
}
