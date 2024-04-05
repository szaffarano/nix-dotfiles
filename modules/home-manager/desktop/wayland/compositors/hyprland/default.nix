{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.desktop.wayland.compositors.hyprland;
in
with lib;
{

  options.desktop.wayland.compositors.hyprland.enable = mkEnableOption "hyprland";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.hyprwm-contrib.grimblast
      hyprpicker
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        input = {
          kb_layout = "us";
          touchpad.disable_while_typing = false;
        };
        general = {
          gaps_in = 5;
          gaps_out = 2;
          border_size = 2.1;
          cursor_inactive_timeout = 4;
          "col.active_border" = "0xff${config.colorscheme.palette.base0C}";
          "col.inactive_border" = "0xff${config.colorscheme.palette.base02}";
          "col.group_border_active" = "0xff${config.colorscheme.palette.base0B}";
          "col.group_border" = "0xff${config.colorscheme.palette.base04}";
        };

        animations = {
          enabled = false;
        };

        bind =
          let
            swaylock = "${config.programs.swaylock.package}/bin/swaylock";
            makoctl = "${config.services.mako.package}/bin/makoctl";
            wofi = "${config.programs.wofi.package}/bin/wofi";
            gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
            xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
            defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";
            terminal = config.home.sessionVariables.TERMINAL;
            editor = defaultApp "text/plain";
          in
          [
            "SUPER,Return,exec,${terminal}"
            "SUPER,v,exec,${editor}"
          ]
          ++

            # Screen lock
            (lib.optionals config.programs.swaylock.enable [ "SUPER,backspace,exec,${swaylock}" ])
          ++

            # Notification manager
            (lib.optionals config.services.mako.enable [ "SUPER,w,exec,${makoctl} dismiss" ])
          ++

            # Launcher
            (lib.optionals config.programs.wofi.enable [
              "SUPER,x,exec,${wofi} -S drun -x 10 -y 10 -W 25% -H 60%"
              "SUPER,d,exec,${wofi} -S run"
            ]);
      };
    };
  };
}
