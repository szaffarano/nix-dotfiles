{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.xorg.feh;
  feh = "${pkgs.feh}/bin/feh";
  wallpaper = lib.getExe pkgs.wallpaper;
in
  with lib; {
    options.desktop.xorg.feh.enable = mkEnableOption "feh wallpaper";

    config = mkIf cfg.enable {
      home.packages = [pkgs.feh];

      xsession.windowManager.i3.config.startup = mkIf config.desktop.xorg.compositors.i3.enable [
        {
          command = ''${feh} --no-fehbg --bg-fill "$(${wallpaper} -o 2>/dev/null)" || true'';
          always = true;
          notification = false;
        }
      ];
    };
  }
