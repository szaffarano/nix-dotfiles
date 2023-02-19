_:
{ config, lib, pkgs, ... }:

{
  options.xdg.config.enable = lib.mkEnableOption "xdg.config";
  config = lib.mkIf config.xdg.config.enable {
    home.packages = with pkgs; [ xdg-utils ];

    xdg = {
      enable = true;
      mime.enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = "org.pwmt.zathura.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "text/html" = "firefox.desktop";
        };
      };

      dataFile."applications/mimeapps.list".force = true;
      configFile."mimeapps.list".force = true;

      systemDirs = {
        config = [ ];
        data = [ ];
      };

      userDirs = {
        enable = true;
        createDirectories = true;
        desktop = "$HOME/Desktop";
        documents = "$HOME/Documents";
        download = "$HOME/Downloads";
        music = "$HOME/Music";
        pictures = "$HOME/Pictures";
        publicShare = "$HOME/Public";
        templates = "$HOME/Templates";
        videos = "$HOME/Videos";

        extraConfig = { XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots"; };
      };
    };
  };
}
