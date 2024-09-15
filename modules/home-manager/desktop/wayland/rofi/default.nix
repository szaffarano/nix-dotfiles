{ config
, inputs
, lib
, pkgs
, ...
}:
let
  cfg = config.desktop.wayland.rofi;
in
with lib;
{
  options.desktop.wayland.rofi.enable = mkEnableOption "rofi";

  config =
    let
      copy = "${pkgs.wl-clipboard}/bin/wl-copy";
      rofi = lib.getExe config.programs.rofi.finalPackage;
      cmd = "${rofi} -show calc -modi calc -no-show-match -no-sort | ${copy}";
    in
    mkIf cfg.enable {
      xdg.dataFile."rofi/themes/${config.scheme.slug}.rasi".text = builtins.readFile (
        config.scheme inputs.base16-rofi
      );

      home.packages = [
        pkgs.rofi-power-menu
      ];

      wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
        keybindings = {
          "${config.wayland.windowManager.sway.config.modifier}+Shift+S" = cmd;
        };
      };

      wayland.windowManager.hyprland.settings =
        lib.mkIf config.desktop.wayland.compositors.hyprland.enable
          {
            bind = [
              "$mod_SHIFT,S,exec,${cmd}"
            ];
          };

      programs.rofi =
        let
          rofi = pkgs.rofi-wayland;
        in
        {
          enable = true;
          package = rofi;
          plugins = [
            (pkgs.rofi-calc.override { rofi-unwrapped = rofi; })
          ];
          theme = config.scheme.slug;
        };
    };
}
