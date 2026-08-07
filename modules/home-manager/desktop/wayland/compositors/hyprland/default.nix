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
        configType = "lua";
        xwayland.enable = true;
        systemd = {
          enable = true;
          # Same as default, but stop graphical-session too
          extraCommands = lib.mkBefore [
            "systemctl --user stop graphical-session.target"
            "systemctl --user start hyprland-session.target"
          ];
        };

        # Migrated to the Lua config backend (hyprlang is being removed upstream).
        # Each top-level attribute maps to an `hl.<name>(...)` call; list values
        # generate one call per element. Raw Lua expressions are produced with
        # `lib.generators.mkLuaInline`.
        settings = {
          # https://wiki.hypr.land/Configuring/Basics/Variables/
          config = {
            general = {
              layout = "dwindle";
              gaps_out = 3;
              gaps_in = 1;
              border_size = 1;
              resize_on_border = true;
              col = {
                active_border = rgb config.colorScheme.palette.base0A;
                inactive_border = rgb config.colorScheme.palette.base03;
              };
            };

            cursor.inactive_timeout = 10;

            debug.disable_logs = false;

            group = {
              col = {
                border_inactive = rgb config.colorScheme.palette.base0D;
                border_active = rgb config.colorScheme.palette.base06;
                border_locked_active = rgb config.colorScheme.palette.base06;
              };
              groupbar = {
                col = {
                  active = rgb config.colorScheme.palette.base02;
                  inactive = rgb config.colorScheme.palette.base01;
                };
                font_size = config.fontProfiles.monospace.sizeAsInt;
                font_weight_active = "bold";
                gradients = true;
                text_color = rgb config.colorScheme.palette.base05;
              };
            };

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
              shadow.enabled = false;
            };

            animations.enabled = false;

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

            dwindle.split_width_multiplier = 1.35;
          };

          # https://wiki.hypr.land/Configuring/Basics/Monitors/
          monitor = [
            {
              output = "desc:LG Electronics LG HDR 4K 301MAPNGQZ84";
              mode = "3840x2160@60";
              position = "0x0";
              scale = 1.5;
            }
            {
              output = "";
              mode = "preferred";
              position = "auto";
              scale = 1;
            }
          ];

          # Autostart: https://wiki.hypr.land/Configuring/Basics/Autostart/
          on = let
            devTerminal = ''${terminal} -a dev-terminal ${pkgs.fish}/bin/fish -c "tmux attach -s random || tmux new -s random"'';
            configureGtk = "${pkgs.configure-gtk}/bin/configure-gtk '${theme.gtk.theme}' '${theme.gtk.cursor-theme}' '${theme.gtk.icon-theme}' '${config.fontProfiles.regular.name}' '${config.fontProfiles.monospace.name}' ";
          in {
            _args = [
              "hyprland.start"
              (lib.generators.mkLuaInline ''
                function()
                  hl.exec_cmd([[${devTerminal}]], { float = true, tile = true })
                  hl.exec_cmd([[${configureGtk}]])
                end'')
            ];
          };

          # https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
          workspace_rule = let
            foot = lib.getExe pkgs.foot;
            telegram = lib.getExe pkgs.telegram-desktop;
            slack = "${lib.getExe pkgs.slack} --enable-features=UseOzonePlatform --ozone-platform=wayland";
            temporis = lib.getExe pkgs.inputs.temporis.temporis-desktop;
            orgmode = "[float] ${foot} -a orgmode ${lib.getExe config.programs.neovim.finalPackage} +Agenda";
            hackernews = "[float] ${foot} -a hackernews ${lib.getExe pkgs.hackernews-tui}";
            musicPlayer = "[float] ${foot} -a musicPlayer ${config.terminal.cli.spotify.exe}";
          in [
            {
              workspace = "special:telegram";
              on_created_empty = telegram;
            }
            {
              workspace = "special:slack";
              on_created_empty = slack;
            }
            {
              workspace = "special:temporis";
              on_created_empty = temporis;
            }
            {
              workspace = "special:orgmode";
              on_created_empty = orgmode;
            }
            {
              workspace = "special:hackernews";
              on_created_empty = hackernews;
            }
            {
              workspace = "special:musicPlayer";
              on_created_empty = musicPlayer;
            }
          ];

          # https://wiki.hypr.land/Configuring/Basics/Window-Rules/#layer-rules
          layer_rule = [
            {
              match.namespace = "^waybar$";
              animation = "fade";
              blur = true;
              ignore_alpha = 0;
            }
            {
              match.namespace = "^swaync-control-center$";
              blur = true;
              ignore_alpha = 0;
            }
            {
              match.namespace = "^wofi$";
              blur = true;
              ignore_alpha = 0;
            }
          ];

          # https://wiki.hypr.land/Configuring/Basics/Window-Rules/
          window_rule = [
            {
              match.class = "^(firefox)$";
              workspace = "name:1";
            }
            {
              match.class = "^(jetbrains-idea)$";
              workspace = "name:2";
            }
            {
              match.class = "^(dev-terminal)$";
              workspace = "name:3";
            }

            {
              match.class = "^(com.zaffa.loppis)$";
              float = true;
            }
            {
              match.class = "^(xdg-desktop-portal-gtk)$";
              float = true;
            }
            {
              match.class = "^(org.keepassxc.KeePassXC)$";
              float = true;
            }
            {
              match.class = "^(nm-connection-editor)$";
              float = true;
            }
            {
              match.class = "^(.blueman-manager-wrapped)$";
              float = true;
            }
            {
              match.class = "^(blueman-manager)$";
              float = true;
            }
            {
              match.class = "^(transmission-qt)$";
              float = true;
            }
            {
              match.class = "^(org.pulseaudio.pavucontrol)$";
              float = true;
            }
            {
              match.class = "^Zoom$";
              float = true;
            }
            {
              match.class = "^udiskie$";
              float = true;
            }

            {
              match = {
                class = "^Zoom$";
                title = "Meeting chat";
              };
              float = true;
              move = "100%-w-20 30%";
              size = "(monitor_w*0.15) (monitor_h*0.60)";
            }
            {
              match = {
                class = "^Zoom$";
                title = "Webinar chat";
              };
              float = true;
              move = "100%-w-20 30%";
              size = "(monitor_w*0.15) (monitor_h*0.60)";
            }
            {
              match = {
                class = "^Zoom$";
                title = "^Participants.*$";
              };
              float = true;
              move = "100%-w-20 30%";
              size = "(monitor_w*0.15) (monitor_h*0.60)";
            }

            {
              match.class = "^(pavucontrol)$";
              float = true;
              size = "(monitor_w*0.60) (monitor_h*0.60)";
              center = true;
            }
            {
              match.class = "^(orgmode)$";
              float = true;
              size = "(monitor_w*0.70) (monitor_h*0.80)";
              center = true;
              workspace = "special:orgmode";
            }
            {
              match.class = "^(hackernews)$";
              float = true;
              size = "(monitor_w*0.70) (monitor_h*0.80)";
              center = true;
              workspace = "special:hackernews";
            }
            {
              match.class = "^(musicPlayer)$";
              float = true;
              size = "(monitor_w*0.50) (monitor_h*0.50)";
              center = true;
              workspace = "special:musicPlayer";
            }
            {
              match.class = "^(slack)$";
              float = true;
              size = "(monitor_w*0.70) (monitor_h*0.80)";
              center = true;
              workspace = "special:slack";
            }
            {
              match.class = "^(org.telegram.desktop)$";
              float = true;
              size = "(monitor_w*0.50) (monitor_h*0.40)";
              center = true;
              workspace = "special:telegram";
            }
            {
              match.class = "^(com.reciperium.temporis)$";
              float = true;
              size = "(monitor_w*0.60) (monitor_h*0.70)";
              center = true;
              workspace = "special:temporis";
            }
          ];
        };
      };
    };
  }
