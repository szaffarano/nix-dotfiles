{ config, lib, pkgs, ... }:
let cfg = config.desktop.tools.screenshot;
in with lib; {

  options.desktop.tools.screenshot.enable = mkEnableOption "screenshot";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ swappy sway-contrib.grimshot ];

    xdg.configFile."swappy/config".text = ''
      [Default]
      save_dir=${config.home.homeDirectory}/Pictures/Screenshots
      show_panel=true
      early_exit=true
    '';

    # TODO: parameterize
    # TODO: make it hyprland compliant or move as a sway's child module
    wayland.windowManager.sway.config =
      let
        grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
        swappy = "${pkgs.swappy}/bin/swappy";
      in
      {
        keybindings = lib.mkDefault {
          "Print" = "exec ${grimshot} save area - | ${swappy} -f -";
          "Shift+Print" = "exec ${grimshot} save screen";
        };
      };
  };
}
