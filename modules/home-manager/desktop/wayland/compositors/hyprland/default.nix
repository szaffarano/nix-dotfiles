{
  config,
  lib,
  pkgs,
  theme,
  ...
}: let
  cfg = config.desktop.wayland.compositors.hyprland;
  terminal = config.home.sessionVariables.TERMINAL;
  rgb = color: "rgb(${color})";
in
  with lib; {
    options.desktop.wayland.compositors.hyprland.enable = mkEnableOption "hyprland";

    imports = [
      ./fish.nix
      ./hypridle.nix
      ./hyprlock.nix
      ./keybindings.nix
      ./zsh.nix
    ];

    config = mkIf cfg.enable {
      xdg.portal = let
        hyprland = config.wayland.windowManager.hyprland.package;
        xdph = pkgs.xdg-desktop-portal-hyprland;
        wlr = pkgs.xdg-desktop-portal-wlr;
      in {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = [
          xdph
          wlr
        ];
        configPackages = [hyprland];
      };

      desktop.wayland.swaync.enable = true;

      home.packages = with pkgs; [
        hyprpicker
        resurrect-hyprlock
      ];

      home.sessionVariables = {
        XCURSOR_SIZE = 16;
        XCURSOR_THEME = theme.gtk.cursor-theme;
      };

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
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
            "col.active_border" = rgb config.colorScheme.palette.base0A;
            "col.inactive_border" = rgb config.colorScheme.palette.base03;
          };

          cursor = {
            inactive_timeout = 10;
          };

          debug = {
            disable_logs = false;
          };

          group = {
            "col.border_inactive" = rgb config.colorScheme.palette.base0D;
            "col.border_active" = rgb config.colorScheme.palette.base06;
            "col.border_locked_active" = rgb config.colorScheme.palette.base06;
            groupbar = {
              font_size = config.fontProfiles.monospace.sizeAsInt;
              text_color = rgb config.colorScheme.palette.base05;
              "col.active" = rgb config.colorScheme.palette.base02;
              "col.inactive" = rgb config.colorScheme.palette.base01;
            };
          };

          # https://wiki.hyprland.org/Configuring/Variables/#decoration
          decoration = {
            rounding = 3;
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
            shadow = {
              enabled = false;
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
            repeat_rate = 20;
            repeat_delay = 350;

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
            background_color = rgb config.colorScheme.palette.base00;
            disable_hyprland_logo = true;
            force_default_wallpaper = 0;
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

          exec-once = let
            configure-gtk = "${pkgs.configure-gtk}/bin/configure-gtk";
          in [
            ''[float;tile] $terminal -a dev-terminal ${pkgs.fish}/bin/fish -c "tmux attach -s random || tmux new -s random"''
            "${configure-gtk} '${theme.gtk.theme}' '${theme.gtk.cursor-theme}' '${theme.gtk.icon-theme}' '${config.fontProfiles.regular.name}' '${config.fontProfiles.monospace.name}' "
          ];

          workspace = let
            telegram = lib.getExe pkgs.telegram-desktop;
            slack = "${lib.getExe pkgs.slack} --enable-features=UseOzonePlatform --ozone-platform=wayland";
          in [
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

            "float,class:^(com.zaffa.loppis)$"
            "float,class:^(xdg-desktop-portal-gtk)$"

            "float,class:^(org.keepassxc.KeePassXC)$"
            "float,class:^(nm-connection-editor)$"
            "float,class:^(blueberry.py)$"
            "float,class:^(transmission-qt)$"

            "float,class:^(org.pulseaudio.pavucontrol)$"

            "float,title:Meeting chat,class:zoom"
            "move 100%-w-20 30%,title:Meeting chat,class:zoom"
            "size 15% 60%,title:Meeting chat,class:zoom"

            "float,title:Webinar chat,class:zoom"
            "move 100%-w-20 30%,title:Meeting chat,class:zoom"
            "size 15% 60%,title:Meeting chat,class:zoom"

            "float,title:^Participants.*$,class:zoom"
            "move 100%-w-20 30%,title:^Participants.*$,class:zoom"
            "size 15% 60%,title:^Participants.*,class:zoom"

            "float,class:^(pavucontrol)$"
            "size 60% 60%,class:^(pavucontrol)$"
            "center,class:^(pavucontrol)$"

            "float,class:^(orgmode)$"
            "size 70% 80%,class:^(orgmode)$"
            "center,class:^(orgmode)$"
            "workspace special:orgmode,class:^(orgmode)$"

            "float,class:^(hackernews)$"
            "size 70% 80%,class:^(hackernews)$"
            "center,class:^(hackernews)$"
            "workspace special:hackernews,class:^(hackernews)$"

            "float,class:^(musicPlayer)$"
            "size 50% 50%,class:^(musicPlayer)$"
            "center,class:^(musicPlayer)$"
            "workspace special:musicPlayer,class:^(musicPlayer)$"

            "float,class:^(Slack)$"
            "size 70% 80%,class:^(Slack)$"
            "center,class:^(Slack)$"
            "stayfocused, class:^(Slack)$"
            "workspace special:Slack,class:^(Slack)$"

            "float,class:^(org.telegram.desktop)$"
            "size 50% 40%,class:^(org.telegram.desktop)$"
            "center,class:^(org.telegram.desktop)$"
            "workspace special:telegram,class:^(org.telegram.desktop)$"
          ];
        };
      };
    };
  }
