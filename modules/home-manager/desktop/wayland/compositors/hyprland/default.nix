{
  config,
  lib,
  pkgs,
  inputs,
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
      inputs.hyprland-contrib.packages.${pkgs.hostPlatform.system}.grimblast
      hyprpicker
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        "$terminal" = "${pkgs.wezterm}/bin/wezterm";

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = 1;

          touchpad = {
            disable_while_typing = true;
            natural_scroll = true;
            clickfinger_behavior = true;
          };
        };

        gestures = {
          workspace_swipe = false;
        };

        general = {
          gaps_in = 5;
          gaps_out = 2;
          border_size = 2;
          # cursor_inactive_timeout = 4;
          #   "col.active_border" = "0xff${config.colorscheme.palette.base0C}";
          #   "col.inactive_border" = "0xff${config.colorscheme.palette.base02}";
          #   "col.group_border_active" = "0xff${config.colorscheme.palette.base0B}";
          #   "col.group_border" = "0xff${config.colorscheme.palette.base04}";
        };

        animations = {
          enabled = false;
        };

        binds = {
          workspace_back_and_forth = true;
        };

        master = {
          new_is_master = true;
        };

        bind =
          let
            makoctl = "${config.services.mako.package}/bin/makoctl";
            wofi = "${config.programs.wofi.package}/bin/wofi";
            wofiPowerMenu = "wofi-power-menu";
          in
          [
            "SUPER,Return,exec,$terminal"
            "SUPER, 1, workspace, 1"
            "SUPER, 2, workspace, 2"
            "SUPER, 3, workspace, 3"
            "SUPER, 4, workspace, 4"
          ]
          ++

            # Screen lock
            (lib.optionals config.programs.swaylock.enable [ "SUPER,backspace,exec,${wofiPowerMenu}" ])
          ++

            # Notification manager
            (lib.optionals config.services.mako.enable [ "SUPER,w,exec,${makoctl} dismiss" ])
          ++

            # Launcher
            (lib.optionals config.programs.wofi.enable [
              "SUPER,x,exec,${wofi} -S drun"
              "SUPER,d,exec,${wofi} -S run"
            ]);
      };
    };
  };
}
