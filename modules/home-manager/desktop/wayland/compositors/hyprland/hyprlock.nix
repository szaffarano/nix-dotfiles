{
  config,
  lib,
  outputs,
  theme,
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
        path = "screenshot";
        noise = 5.0e-2;
        blur_passes = 1;
      };

      input-field = {
        hide_input = false;

        size = "200, 30";

        outer_color = "rgb(151515)";
        inner_color = "rgb(200, 200, 200)";
        font_color = "rgb(10, 10, 10)";

        dots_size = "0.20";
        dots_spacing = "0.1";
      };

      label = {
        color = "rgba(100, 100, 100, 1.0)";
        position = "0, 20";
        font_family = theme.fonts."f-mono";
        font_size = 35;
        halign = "center";
        text = ''cmd[update:10000] echo "<b>$(date '+%H:%M')</b>"'';
        valign = "center";
      };
    } 0;
  };
}
