{ config, lib, ... }:
let cfg = config.desktop.gui;
in with lib; {
  imports = [ ./gtk.nix ./qt.nix ];

  options.desktop.gui.enable = mkEnableOption "gui";

  config = mkIf cfg.enable {
    desktop.gui = {
      gtk.enable = true;
      qt.enable = true;
    };
  };
}
