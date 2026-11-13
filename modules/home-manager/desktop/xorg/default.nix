{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.xorg;
in
  with lib; {
    imports = [
      ./compositors
      ./autorandr.nix
      ./dunst.nix
      ./feh.nix
      ./flameshot.nix
      ./i3lock.nix
      ./i3status-rust.nix
      ./rofi.nix
      ./xautolock.nix
    ];

    options.desktop.xorg.enable = mkEnableOption "xorg";

    config = mkIf cfg.enable {
      desktop.xorg = {
        compositors.enable = lib.mkDefault true;
        autorandr.enable = lib.mkDefault true;
        dunst.enable = lib.mkDefault true;
        feh.enable = lib.mkDefault true;
        flameshot.enable = lib.mkDefault true;
        i3status-rust.enable = lib.mkDefault true;
        rofi.enable = lib.mkDefault true;
      };

      home.packages = with pkgs; [
        (aspellWithDicts (
          dicts:
            with dicts; [
              en
              es
            ]
        ))
        brightnessctl
        gthumb
        imagemagick
        libnotify
        networkmanagerapplet
        pasystray
        pavucontrol
        playerctl
        vlc
        weechat
        xclip
        xdg-utils
        xrandr
        xsel
      ];

      home.sessionVariables = {
        QT_QPA_PLATFORM = "xcb";
      };
    };
  }
