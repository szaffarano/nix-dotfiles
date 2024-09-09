{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.desktop.wayland;
in
with lib;
{

  imports = [
    ./kanshi
    ./swayidle
    ./swaylock
    ./swaync
    ./mako
    ./waybar
    ./wofi
    ./compositors
  ];

  options.desktop.wayland.enable = mkEnableOption "wayland";

  config = mkIf cfg.enable {
    desktop.wayland = {
      mako.enable = lib.mkDefault false;
      wofi.enable = lib.mkDefault true;
      waybar.enable = lib.mkDefault true;
      kanshi.enable = lib.mkDefault true;

      compositors = {
        enable = lib.mkDefault true;
        hyprland.enable = lib.mkDefault false;
        sway.enable = lib.mkDefault true;
      };
    };

    home.packages = with pkgs; [
      (aspellWithDicts (
        dicts: with dicts; [
          en
          en-computers
          es
        ]
      ))
      cliphist
      clipse
      glib
      grim
      gthumb
      gtk3
      imagemagick
      mimeo
      pulseaudio
      slurp
      vlc
      waypipe
      weechat
      wf-recorder
      (wl-clipboard.overrideAttrs (old: {
        patches =
          old.patches or [ ]
          ++ [
            # see https://github.com/bugaevc/wl-clipboard/issues/177
            ./wl-copy.patch
            (pkgs.fetchpatch {
              url = "https://github.com/bugaevc/wl-clipboard/pull/204.patch";
              hash = "sha256-6rljcv5yXzQeCUO6IoP1irM0qUEVgmQ+UA6vcJOYeFs=";
            })
          ];
      }))
      wl-mirror
      xdg-utils
      ydotool
    ];

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      QT_QPA_PLATFORM = "wayland";
      LIBSEAT_BACKEND = "logind";
    };

    # TODO: move to a module
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

        extraConfig = {
          XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots";
        };
      };
    };
  };
}
