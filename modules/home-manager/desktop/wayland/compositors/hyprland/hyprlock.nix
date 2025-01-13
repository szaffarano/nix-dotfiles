{
  config,
  lib,
  localLib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.compositors.hyprland;
  rgb = color: "rgb(${color})";
  rgba = color: alpha: "rgba(${color}${alpha})";
in
  with lib; {
    config = mkIf cfg.enable {
      home.packages = with pkgs; [hyprlock];
      xdg.configFile."hypr/hyprlock.conf".text =
        localLib.toHyprconf {
          general = {
            grace = 5;
          };

          background = {
            path = "${config.home.homeDirectory}/Pictures/screen-lock.png";
          };

          input-field = {
            hide_input = false;

            size = "200, 30";

            outer_color = rgb config.colorScheme.palette.base0A;
            inner_color = rgb config.colorScheme.palette.base00;
            font_color = rgb config.colorScheme.palette.base06;

            dots_size = "0.20";
            dots_spacing = "0.1";
          };

          label = {
            color = rgba config.colorScheme.palette.base0A "1.0";
            position = "0,35";
            font_family = config.fontProfiles.monospace.name;
            font_size = config.fontProfiles.monospace.sizeAsInt * 2;
            halign = "center";
            text = ''cmd[update:10000] echo "<b>$(date '+%H:%M')</b>"'';
            valign = "center";
          };
        }
        0;
    };
  }
