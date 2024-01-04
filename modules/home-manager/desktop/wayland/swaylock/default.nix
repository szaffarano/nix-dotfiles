{ config, lib, pkgs, ... }:
let
  cfg = config.desktop.wayland.swaylock;
  inherit (config.colorscheme) colors;
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

        ring-color = "#${colors.base02}";
        inside-wrong-color = "#${colors.base08}";
        ring-wrong-color = "#${colors.base08}";
        key-hl-color = "#${colors.base0B}";
        bs-hl-color = "#${colors.base08}";
        ring-ver-color = "#${colors.base09}";
        inside-ver-color = "#${colors.base09}";
        inside-color = "#${colors.base01}";
        text-color = "#${colors.base07}";
        text-clear-color = "#${colors.base01}";
        text-ver-color = "#${colors.base01}";
        text-wrong-color = "#${colors.base01}";
        text-caps-lock-color = "#${colors.base07}";
        inside-clear-color = "#${colors.base0C}";
        ring-clear-color = "#${colors.base0C}";
        inside-caps-lock-color = "#${colors.base09}";
        ring-caps-lock-color = "#${colors.base02}";
        separator-color = "#${colors.base02}";
      };
    };
  };
}
