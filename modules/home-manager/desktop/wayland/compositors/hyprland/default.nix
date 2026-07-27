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

      home.pointerCursor = {
        enable = true;
        package = pkgs.adwaita-icon-theme;
        name = theme.gtk.cursor-theme;
        size = 24;
        gtk.enable = true;
        hyprcursor.enable = true;
      };

      wayland.windowManager.hyprland = {
        enable = true;
        configType = "hyprlang";
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
          };

          monitor = [
            "desc:LG Electronics LG HDR 4K 301MAPNGQZ84,3840x2160@60,0x0,1.5"
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
            temporis = lib.getExe pkgs.inputs.temporis.temporis-desktop;
          in [
            "special:telegram, on-created-empty:${telegram}"
            "special:slack, on-created-empty:${slack}"
            "special:temporis, on-created-empty:${temporis}"
          ];
          layerrule = [
            "match:namespace ^waybar$, animation fade"
            "match:namespace ^waybar$, blur on"
            "match:namespace ^waybar$, ignore_alpha 0"
            "match:namespace ^swaync-control-center$, blur on"
            "match:namespace ^swaync-control-center$, ignore_alpha 0"
            "match:namespace ^wofi$, blur on"
            "match:namespace ^wofi$, ignore_alpha 0"
          ];

          windowrule = [
            "match:class ^(firefox)$, workspace name:1"
            "match:class ^(jetbrains-idea)$, workspace name:2"
            "match:class ^(dev-terminal)$, workspace name:3"

            "match:class ^(com.zaffa.loppis)$, float on"
            "match:class ^(xdg-desktop-portal-gtk)$, float on"

            "match:class ^(org.keepassxc.KeePassXC)$, float on"
            "match:class ^(nm-connection-editor)$, float on"
            "match:class ^(.blueman-manager-wrapped)$, float on"
            "match:class ^(transmission-qt)$, float on"

            "match:class ^(org.pulseaudio.pavucontrol)$, float on"

            "match:class ^Zoom$, float on"

            "match:class ^Zoom$ match:title Meeting chat, float on"
            "match:class ^Zoom$ match:title Meeting chat, move 100%-w-20 30%"
            "match:class ^Zoom$ match:title Meeting chat, size 15% 60%"

            "match:class ^Zoom$ match:title Webinar chat, float on"
            "match:class ^Zoom$ match:title Webinar chat, move 100%-w-20 30%"
            "match:class ^Zoom$ match:title Webinar chat, size 15% 60%"

            "match:class ^Zoom$ match:title ^Participants.*$, float on"
            "match:class ^Zoom$ match:title ^Participants.*$, move 100%-w-20 30%"
            "match:class ^Zoom$ match:title ^Participants.*$, size 15% 60%"

            "match:class ^(pavucontrol)$, float on"
            "match:class ^(pavucontrol)$, size 60% 60%"
            "match:class ^(pavucontrol)$, center on"

            "match:class ^(orgmode)$, float on"
            "match:class ^(orgmode)$, size 70% 80%"
            "match:class ^(orgmode)$, center on"
            "match:class ^(orgmode)$, workspace special:orgmode"

            "match:class ^(hackernews)$, float on"
            "match:class ^(hackernews)$, size 70% 80%"
            "match:class ^(hackernews)$, center on"
            "match:class ^(hackernews)$, workspace special:hackernews"

            "match:class ^(musicPlayer)$, float on"
            "match:class ^(musicPlayer)$, size 50% 50%"
            "match:class ^(musicPlayer)$, center on"
            "match:class ^(musicPlayer)$, workspace special:musicPlayer"

            "match:class ^(slack)$, float on"
            "match:class ^(slack)$, size 70% 80%"
            "match:class ^(slack)$, center on"
            "match:class ^(slack)$, workspace special:slack"

            "match:class ^(org.telegram.desktop)$, float on"
            "match:class ^(org.telegram.desktop)$, size 50% 40%"
            "match:class ^(org.telegram.desktop)$, center on"
            "match:class ^(org.telegram.desktop)$, workspace special:telegram"

            "match:class ^(com.reciperium.temporis)$, float on"
            "match:class ^(com.reciperium.temporis)$, size 60% 70%"
            "match:class ^(com.reciperium.temporis)$, center on"
            "match:class ^(com.reciperium.temporis)$, workspace special:temporis"
          ];
        };
      };
    };
  }
