{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop;
in
  with lib; {
    imports = [
      ./audio
      ./gui
      ./messengers
      ./terminal
      ./themes
      ./tools
      ./wayland
      ./web/firefox.nix
      ./web/chromium.nix
    ];

    options.desktop.enable = mkEnableOption "desktop";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        anki

        # books
        calibre
        koreader
        readest

        qview
        speedcrunch
        tor-browser
        transmission_4-qt
        chromium

        fontconfig

        liberation_ttf
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        nerd-fonts.fira-code
      ];

      desktop = {
        audio.enable = lib.mkDefault true;
        gui.enable = lib.mkDefault true;
        messengers.enable = lib.mkDefault true;
        terminal.enable = lib.mkDefault true;
        tools.enable = lib.mkDefault true;
        wayland.enable = lib.mkDefault true;
        web.firefox.enable = lib.mkDefault true;
        web.chromium.enable = lib.mkDefault true;
      };

      fontProfiles.enable = lib.mkDefault true;

      # Session-agnostic defaults shared by the wayland and xorg desktop sessions.
      xdg = {
        enable = true;
        mime.enable = true;
        mimeApps = {
          enable = true;
          defaultApplications = {
            "application/octet-stream" = "org.gnome.gThumb.desktop"; # matplotlib figures
            "application/pdf" = "org.pwmt.zathura.desktop";
            "application/xhtml+xml" = "firefox.desktop";
            "image/gif" = "org.gnome.gThumb.desktop";
            "image/heif" = "org.gnome.gThumb.desktop";
            "image/jpeg" = "org.gnome.gThumb.desktop";
            "image/png" = "org.gnome.gThumb.desktop";
            "image/webp" = "org.gnome.gThumb.desktop";
            "text/html" = "firefox.desktop";
            "text/xml" = "firefox.desktop";
            "video/mp4" = "vlc.desktop";
            "video/quicktime" = "vlc.desktop";
            "video/x-matroska" = "vlc.desktop";
            "video/x-ms-wmv" = "vlc.desktop";
            "x-scheme-handler/http" = "firefox.desktop";
            "x-scheme-handler/https" = "firefox.desktop";
          };
        };

        dataFile."applications/mimeapps.list".force = true;
        configFile."mimeapps.list".force = true;

        systemDirs = {
          config = [];
          data = [];
        };

        userDirs = {
          enable = true;
          createDirectories = true;
          setSessionVariables = true;
          desktop = "$HOME/Desktop";
          documents = "$HOME/Documents";
          download = "$HOME/Downloads";
          music = "$HOME/Music";
          pictures = "$HOME/Pictures";
          publicShare = "$HOME/Public";
          templates = "$HOME/Templates";
          videos = "$HOME/Videos";

          extraConfig = {
            SCREENSHOTS = "$HOME/Pictures/Screenshots";
          };
        };
      };
    };
  }
