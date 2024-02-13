{ config, lib, pkgs, ... }:
let cfg = config.desktop;
in with lib; {
  imports = [
    ./audio
    ./fonts
    ./gui
    ./messengers
    ./terminal
    ./themes
    ./tools
    ./wayland
    ./web/firefox.nix
  ];

  options.desktop.enable = mkEnableOption "desktop";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      anki
      calibre
      qview
      speedcrunch
      tor-browser-bundle-bin
      transmission-qt
      ungoogled-chromium
    ];

    desktop = {
      audio.enable = lib.mkDefault true;
      gui.enable = lib.mkDefault true;
      messengers.enable = lib.mkDefault true;
      terminal.enable = lib.mkDefault true;
      tools.enable = lib.mkDefault true;
      wayland.enable = lib.mkDefault true;
      web.firefox.enable = lib.mkDefault true;
    };
  };
}
