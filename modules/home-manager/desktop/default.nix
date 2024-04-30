{
  config,
  lib,
  pkgs,
  ...
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
      transmission-qt
      chromium

      fontconfig

      liberation_ttf
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
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

    fontProfiles = {
      enable = lib.mkDefault true;
      monospace = {
        family = "sans-serif";
        name = "FiraCode Nerd Font";
        size = "11px";
        package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
      };
      regular = {
        family = "liberation-sans";
        name = "Liberation Sans";
        size = "10px";
        package = pkgs.liberation_ttf;
      };
    };
  };
}
