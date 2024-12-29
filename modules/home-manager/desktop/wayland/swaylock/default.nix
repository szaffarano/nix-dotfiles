{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.swaylock;
  colors = config.colorScheme.palette;
  inside = "#${colors.base01}";
  outside = "#${colors.base01}";
  ring = "#${colors.base05}";
  text = "#${colors.base05}";
  positive = "#${colors.base0B}";
  negative = "#${colors.base08}";
in
  with lib; {
    options.desktop.wayland.swaylock.enable = mkEnableOption "swaylock";

    config = mkIf cfg.enable {
      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        settings = {
          line-uses-inside = true;
          disable-caps-lock-text = true;
          indicator-caps-lock = true;
          show-failed-attempts = true;
          indicator-thickness = 7;
          indicator-radius = 50;
          indicator-idle-visible = true;

          color = outside;
          scaling = "fill";
          inside-color = inside;
          inside-clear-color = inside;
          inside-caps-lock-color = inside;
          inside-ver-color = inside;
          inside-wrong-color = inside;
          key-hl-color = positive;
          layout-bg-color = inside;
          layout-border-color = ring;
          layout-text-color = text;
          ring-color = ring;
          ring-clear-color = negative;
          ring-caps-lock-color = ring;
          ring-ver-color = positive;
          ring-wrong-color = negative;
          separator-color = "00000000";
          text-color = text;
          text-clear-color = text;
          text-caps-lock-color = text;
          text-ver-color = text;
          text-wrong-color = text;
        };
      };
    };
  }
