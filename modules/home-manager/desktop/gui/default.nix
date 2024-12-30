{
  config,
  lib,
  ...
}: let
  cfg = config.desktop.gui;
in
  with lib; {
    imports = [
      ./gtk.nix
      ./qt.nix
      ./fontconfig
    ];

    options.desktop.gui.enable = mkEnableOption "gui";

    config = mkIf cfg.enable {
      desktop.gui = {
        gtk.enable = mkDefault true;
        qt.enable = mkDefault true;
        fontconfig.enable = mkDefault true;
      };
    };
  }
