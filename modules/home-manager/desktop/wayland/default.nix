{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland;
in
  with lib; {
    imports = [
      ./compositors
      ./kanshi
      ./mako
      ./rofi
      ./shikane
      ./swayidle
      ./swaylock
      ./swaync
      ./waybar
      ./wofi
      ./wpaperd
    ];

    options.desktop.wayland.enable = mkEnableOption "wayland";

    config = mkIf cfg.enable {
      desktop.wayland = {
        kanshi.enable = lib.mkDefault true;
        mako.enable = lib.mkDefault false;
        rofi.enable = lib.mkDefault true;
        shikane.enable = lib.mkDefault false;
        waybar.enable = lib.mkDefault true;
        wofi.enable = lib.mkDefault true;
        wpaperd.enable = lib.mkDefault true;

        compositors = {
          enable = lib.mkDefault true;
          hyprland.enable = lib.mkDefault false;
          sway.enable = lib.mkDefault true;
        };
      };

      home.packages = with pkgs; [
        (aspellWithDicts (
          dicts:
            with dicts; [
              en
              es
            ]
        ))
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
        wl-mirror
        xdg-utils
        ydotool
      ];

      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        QT_QPA_PLATFORM = "wayland";
        LIBSEAT_BACKEND = "logind";
      };
    };
  }
