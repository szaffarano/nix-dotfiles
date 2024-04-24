{
  config,
  lib,
  outputs,
  pkgs,
  ...
}:
let
  cfg = config.desktop.wayland.compositors.hyprland;
in
with lib;
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ hyprlock ];
    xdg.configFile."hypr/hyprlock.conf".text = outputs.lib.toHyprconf {
      background = {
        monitor = "";
        path = "screenshot";
        blur_passes = 2;
        blur_size = 4;
        noise = 5.0e-2;
        contrast = 0.8;
        brightness = 0.4;
        vibrancy = 0.2;
        vibrancy_darkness = 0.1;
      };

      input-field = {
        monitor = "";
        size = "250, 40";
        outline_thickness = "2";
        dots_size = "0.20";
        dots_spacing = "0.1";
        dots_center = false;
        outer_color = "rgb(0, 0, 0)";
        inner_color = "rgb(200, 200, 200)";
        font_color = "rgb(60, 90, 30)";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        fade_on_empty = true;
        placeholder_text = "<i>Input Password...</i>";
        hide_input = false;
        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      label = {
        monitor = "";
        text = ''cmd[update:1000] echo "<b>$(date '+%Y-%m-%d %H:%M:%S %Z')</b>"'';
        color = "rgba(100, 100, 100, 1.0)";
        font_size = 25;
        font_family = "Noto Sans";
        position = "0, 80";
        halign = "center";
        valign = "center";
      };
    } 0;
  };
}
