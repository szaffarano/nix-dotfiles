{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.rofi;
in
  with lib; {
    imports = [../../rofi/default.nix];
    options.desktop.wayland.rofi.enable = mkEnableOption "rofi";

    config = let
      copy = "${pkgs.wl-clipboard}/bin/wl-copy";
      rofi = lib.getExe config.programs.rofi.finalPackage;
      rofiCalc = "${rofi} -show calc -modi calc -no-show-match -no-sort -calc-command '${copy} {result}'";
      rofiPowerMenu = builtins.concatStringsSep " " (lib.splitString "\n" ''
        ${lib.getExe config.programs.rofi.package}
          -show p
          -modi 'p:rofi-power-menu --choices=suspend/logout/lockscreen/reboot/shutdown/hibernate'
          -theme-str 'window {width: 8em;} listview {lines: 5;scrollbar: false;}'
      '');
    in
      mkIf cfg.enable {
        desktop.rofi.enable = true;

        home.packages = [
          pkgs.rofi-power-menu
          pkgs.inputs.rofi-tools.rofi-cliphist
        ];

        wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
          keybindings = let
            inherit (config.wayland.windowManager.sway.config) modifier;
          in {
            "${modifier}+Shift+S" = "exec ${rofiCalc}";

            "${modifier}+d" = "exec ${rofi} -show run";
            "${modifier}+x" = "exec ${rofi} -show drun";
            "${modifier}+BackSpace" = "exec ${rofiPowerMenu}";
          };
        };

        wayland.windowManager.hyprland.settings =
          lib.mkIf config.desktop.wayland.compositors.hyprland.enable
          {
            bind = [
              {
                _args = ["SUPER + SHIFT + s" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON rofiCalc})")];
              }
              {
                _args = ["SUPER + x" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${rofi} -show drun"})")];
              }
              {
                _args = ["SUPER + d" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${rofi} -show run"})")];
              }
              {
                _args = ["SUPER + backspace" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON rofiPowerMenu})")];
              }
            ];
          };

        programs.rofi. enable = true;
      };
  }
