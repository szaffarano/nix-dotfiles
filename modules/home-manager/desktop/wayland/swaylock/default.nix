{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.wayland.swaylock;
  inherit (config.colorscheme) palette;
in
with lib;
{
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

        ring-color = "#${palette.base02}";
        inside-wrong-color = "#${palette.base08}";
        ring-wrong-color = "#${palette.base08}";
        key-hl-color = "#${palette.base0B}";
        bs-hl-color = "#${palette.base08}";
        ring-ver-color = "#${palette.base09}";
        inside-ver-color = "#${palette.base09}";
        inside-color = "#${palette.base01}";
        text-color = "#${palette.base07}";
        text-clear-color = "#${palette.base01}";
        text-ver-color = "#${palette.base01}";
        text-wrong-color = "#${palette.base01}";
        text-caps-lock-color = "#${palette.base07}";
        inside-clear-color = "#${palette.base0C}";
        ring-clear-color = "#${palette.base0C}";
        inside-caps-lock-color = "#${palette.base09}";
        ring-caps-lock-color = "#${palette.base02}";
        separator-color = "#${palette.base02}";
      };
    };
  };
}
