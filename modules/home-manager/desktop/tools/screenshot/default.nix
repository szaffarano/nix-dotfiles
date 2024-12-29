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

    config = mkIf cfg.enable {
      xdg.configFile."swappy/config".source = (pkgs.formats.ini {}).generate "swappy" {
        Default = {
          save_dir = "${config.home.homeDirectory}/Pictures/Screenshots";
          show_panel = true;
          early_exit = true;
        };
      };

      home.packages = with pkgs;
        [swappy]
        ++ (lib.optionals config.desktop.wayland.compositors.sway.enable [sway-contrib.grimshot])
        ++ (lib.optionals config.desktop.wayland.compositors.hyprland.enable [
          pkgs.inputs.hyprland-contrib.grimblast
        ]);

      wayland.windowManager.sway.config = let
        grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
        swappy = "${pkgs.swappy}/bin/swappy";
      in
        lib.mkIf config.desktop.wayland.compositors.sway.enable {
          keybindings = lib.mkDefault {
            "Print" = "exec ${grimshot} save area - | ${swappy} -f -";
            "Shift+Print" = "exec ${grimshot} save screen";
          };
        };

      wayland.windowManager.hyprland.settings = let
        grimblast = lib.getExe pkgs.inputs.hyprland-contrib.grimblast;
        swappy = lib.getExe pkgs.swappy;
      in
        lib.mkIf config.desktop.wayland.compositors.hyprland.enable {
          bind = [
            ", Print, exec, ${grimblast} save area - | ${swappy} -f -"
            "SHIFT, Print, exec, ${grimblast} save screen - | ${swappy} -f -"
          ];
        };
    };
  }
