{ config, lib, pkgs, ... }:
let cfg = config.desktop.wayland;
in with lib; {

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
      mako.enable = false;
      wofi.enable = true;
      waybar.enable = true;
      kanshi.enable = true;
      swayidle.enable = true;
      swaylock.enable = true;
      swaync.enable = true;

      compositors = {
        hyprland.enable = false;
        sway.enable = true;
      };
    };

    home.packages = with pkgs; [
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science es ]))
      glib
      grim
      gtk3 # For gtk-launch
      imagemagick
      imv
      mimeo
      pulseaudio
      slurp
      waypipe
      weechat
      wf-recorder
      wl-clipboard
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
