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
      audio.enable = true;
      gui.enable = true;
      messengers.enable = true;
      terminal.enable = true;
      tools.enable = true;
      wayland.enable = true;
      web.firefox.enable = true;
    };
  };
}
