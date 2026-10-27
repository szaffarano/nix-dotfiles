{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.tools.screenshot;
in
  with lib; {
    options.desktop.tools.screenshot.enable = mkEnableOption "screenshot";

    config = let
      sattyBin = lib.getExe pkgs.satty;
    in
      mkIf cfg.enable {
        xdg.configFile."satty/config.toml".source = (pkgs.formats.toml {}).generate "satty" {
          general = {
            output-filename = "~/Pictures/Screenshots/screenshot-%Y-%m-%d_%H:%M:%S.png";
          };
        };

        home.packages = with pkgs;
          [satty]
          ++ (lib.optionals config.desktop.wayland.compositors.sway.enable [sway-contrib.grimshot])
          ++ (lib.optionals config.desktop.wayland.compositors.hyprland.enable [
            pkgs.inputs.hyprland-contrib.grimblast
          ]);

        wayland.windowManager.sway.config = let
          grimshot = lib.getExe pkgs.sway-contrib.grimshot;
        in
          lib.mkIf config.desktop.wayland.compositors.sway.enable {
            keybindings = {
              "Print" = "exec ${grimshot} save area - | ${sattyBin} -f -";
              "Shift+Print" = "exec ${grimshot} save screen";
            };
          };

        wayland.windowManager.hyprland.settings = let
          grimblast = lib.getExe pkgs.inputs.hyprland-contrib.grimblast;
        in
          lib.mkIf config.desktop.wayland.compositors.hyprland.enable {
            bind = [
              {
                _args = [
                  "Print"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${grimblast} save area - | ${sattyBin} -f -"})")
                ];
              }
              {
                _args = [
                  "SHIFT + Print"
                  (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${grimblast} save screen - | ${sattyBin} -f -"})")
                ];
              }
            ];
          };
      };
  }
