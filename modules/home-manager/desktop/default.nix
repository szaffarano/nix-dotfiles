{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.desktop;
in
with lib;
{
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
      foliate
      koodo-reader

      qview
      speedcrunch
      tor-browser-bundle-bin
      # transmission_4-qt
      chromium

      fontconfig

      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
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
  };
}
