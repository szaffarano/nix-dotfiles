{ config
, lib
, pkgs
, theme
, ...
}:
let
  inherit (config) scheme;
  cfg = config.desktop.wayland.compositors.hyprland;
  terminal = config.home.sessionVariables.TERMINAL;
  rgb = color: "rgb(${color})";
  rgba = color: alpha: "rgba(${color}${alpha})";
in
with lib;
{
  options.desktop.wayland.compositors.hyprland.enable = mkEnableOption "hyprland";

  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./keybindings.nix
    ./wpaperd.nix
  ];

  config = mkIf cfg.enable {

    desktop.wayland.swaync.enable = true;

    home.packages = with pkgs; [ hyprpicker ];

    home.sessionVariables = {
      XCURSOR_SIZE = 16;
      XCURSOR_THEME = theme.gtk.cursor-theme;
    };

    programs.zsh.loginExtra = ''
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec ${lib.getExe pkgs.hyprland} \
          > ~/.cache/hyprland.log 2>~/.cache/hyprland.err.log
      fi
    '';

    wayland.windowManager.hyprland = {
      enable = true;
      systemd = {
        enable = true;
        # Same as default, but stop graphical-session too
        extraCommands = lib.mkBefore [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };

      settings = {
        "$terminal" = terminal;
        "$mod" = "SUPER";

        # https://wiki.hyprland.org/Configuring/Variables/#general
        general = {
          layout = "dwindle";
          gaps_out = 3;
          gaps_in = 1;
          border_size = 1;
          resize_on_border = true;
          "col.active_border" = rgb scheme.base0A;
          "col.inactive_border" = rgb scheme.base03;
        };

        cursor = {
          inactive_timeout = 10;
        };

        debug = {
          disable_logs = false;
        };

        group = {
          "col.border_inactive" = rgb scheme.base0D;
          "col.border_active" = rgb scheme.base06;
          "col.border_locked_active" = rgb scheme.base06;
          groupbar = {
            font_size = config.fontProfiles.monospace.sizeAsInt;
            text_color = rgb scheme.base05;
            "col.active" = rgb scheme.base02;
            "col.inactive" = rgb scheme.base01;
          };
        };

        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        decoration = {
          rounding = 3;
          drop_shadow = 0;
          "col.shadow" = rgba scheme.base00 "99";
          active_opacity = 0.99;
          inactive_opacity = 0.93;
          fullscreen_opacity = 1.0;
          blur = {
            enabled = true;
            size = 5;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = true;
            popups = true;
          };
        };

        animations = {
          enabled = false;
        };

        # https://wiki.hyprland.org/Configuring/Variables/#input
        input = {
          kb_layout = "us,us";
          kb_variant = "altgr-intl,dvorak";
          kb_options = "grp:rctrl_ralt_toggle";
          repeat_rate = 25;
          repeat_delay = 250;

          follow_mouse = 0;

          touchpad = {
            disable_while_typing = true;
            clickfinger_behavior = true;
          };
        };

        # https://wiki.hyprland.org/Configuring/Variables/#misc
        misc = {
          close_special_on_empty = true;
          focus_on_activate = true;
          new_window_takes_over_fullscreen = 2;
          background_color = rgb scheme.base00;
        };

        binds = {
          workspace_back_and_forth = true;
          movefocus_cycles_fullscreen = false;
        };

        # https://wiki.hyprland.org/Configuring/Dwindle-Layout/#config
        dwindle = {
          split_width_multiplier = 1.35;
          pseudotile = true;
        };

        monitor = [
          "desc:LG Electronics LG HDR 4K 301MAPNGQZ84,2560x1440,auto,1"
          "HDMI-A-1,highres,auto,1"
          ",preferred,auto,1"
        ];

        exec-once =
          let
            configure-gtk = "${pkgs.configure-gtk}/bin/configure-gtk";
          in
          [
            ''[float;tile] $terminal -a dev-terminal zsh --login -c "tmux attach -t random || tmux new -s random"''
            ''${configure-gtk} '${theme.gtk.theme}' '${theme.gtk.cursor-theme}' '${theme.gtk.icon-theme}' '${config.fontProfiles.regular.name}' '${config.fontProfiles.monospace.name}' ''
          ]
          ++ (lib.optionals config.desktop.tools.keepassxc.enable [ "${pkgs.keepassxc}/bin/keepassxc" ]);

        workspace =
          let
            telegram = lib.getExe pkgs.telegram-desktop;
            slack = "${lib.getExe pkgs.slack} --enable-features=UseOzonePlatform --ozone-platform=wayland";
          in
          [
            "special:telegram, on-created-empty:${telegram}"
            "special:Slack, on-created-empty:${slack}"
          ];
        layerrule = [
          "animation fade,waybar"
          "blur,waybar"
          "ignorezero,waybar"
          "blur,swaync-control-center"
          "ignorezero,swaync-control-center"
          "blur,wofi"
          "ignorezero,wofi"
        ];

        windowrulev2 = [
          "workspace name:1,class:^(firefox)$"
          "workspace name:2,class:^(jetbrains-idea)$"
          "workspace name:3,class:^(dev-terminal)$"

          "float,class:^(org\.keepassxc\.KeePassXC)$"
          "float,class:^(com\.github\.hluk\.copyq)$"
          "float,class:^(nm-connection-editor)$"
          "float,class:^(blueberry.py)$"
          "float,class:^(transmission-qt)$"

          "float,class:^(org.pulseaudio.pavucontrol)$"

          "float,class:^(pavucontrol)$"
          "size 60% 60%,class:^(pavucontrol)$"
          "center,class:^(pavucontrol)$"

          "float,class:^(orgmode)$"
          "size 70% 80%,class:^(orgmode)$"
          "center,class:^(orgmode)$"
          "workspace special:orgmode,class:^(orgmode)$"

          "float,class:^(musicPlayer)$"
          "size 50% 50%,class:^(musicPlayer)$"
          "center,class:^(musicPlayer)$"
          "workspace special:musicPlayer,class:^(musicPlayer)$"

          "float,class:^(Slack)$"
          "size 70% 80%,class:^(Slack)$"
          "center,class:^(Slack)$"
          "stayfocused, class:^(Slack)$"
          "workspace special:Slack,class:^(Slack)$"

          "float,class:^(org\.telegram\.desktop)$"
          "size 50% 40%,class:^(org\.telegram\.desktop)$"
          "center,class:^(org\.telegram\.desktop)$"
          "workspace special:telegram,class:^(org\.telegram\.desktop)$"
        ];
      };
    };
  };
}
