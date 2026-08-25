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

  foot = lib.getExe pkgs.foot;
  telegram = lib.getExe pkgs.telegram-desktop;
  slack = "${lib.getExe pkgs.slack} --enable-features=UseOzonePlatform --ozone-platform=wayland";
  temporis = lib.getExe pkgs.inputs.temporis.temporis-desktop;
  orgmode = "${foot} -a orgmode ${lib.getExe config.programs.neovim.finalPackage} +Agenda";
  hackernews = "${foot} -a hackernews ${lib.getExe pkgs.hackernews-tui}";
  musicPlayer = "${foot} -a musicPlayer ${config.terminal.cli.spotify.exe}";
  termScratch = "${foot} -a termScratch";

  mkSpecialWorkspace = {
    name,
    cmd,
    class ? name,
    size,
  }: {
    workspace_rule = {
      workspace = "special:${name}";
      on_created_empty = cmd;
    };
    window_rule = {
      match.class = "^(${class})$";
      float = true;
      inherit size;
      center = true;
      workspace = "special:${name}";
    };
  };

  specialWorkspaces = map mkSpecialWorkspace [
    {
      name = "telegram";
      cmd = telegram;
      class = "org.telegram.desktop";
      size = "(monitor_w*0.50) (monitor_h*0.40)";
    }
    {
      name = "slack";
      cmd = slack;
      size = "(monitor_w*0.70) (monitor_h*0.80)";
    }
    {
      name = "temporis";
      cmd = temporis;
      class = "com.reciperium.temporis";
      size = "(monitor_w*0.60) (monitor_h*0.70)";
    }
    {
      name = "orgmode";
      cmd = orgmode;
      size = "(monitor_w*0.70) (monitor_h*0.80)";
    }
    {
      name = "hackernews";
      cmd = hackernews;
      size = "(monitor_w*0.70) (monitor_h*0.80)";
    }
    {
      name = "musicPlayer";
      cmd = musicPlayer;
      size = "(monitor_w*0.50) (monitor_h*0.50)";
    }
    {
      name = "termScratch";
      cmd = termScratch;
      size = "(monitor_w*0.70) (monitor_h*0.60)";
    }
  ];

  floatClasses = [
    "com.zaffa.loppis"
    "xdg-desktop-portal-gtk"
    "org.keepassxc.KeePassXC"
    "nm-connection-editor"
    ".blueman-manager-wrapped"
    "blueman-manager"
    "transmission-qt"
    "org.pulseaudio.pavucontrol"
    "Zoom"
    "udiskie"
  ];

  zoomSize = "(monitor_w*0.15) (monitor_h*0.60)";
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
                  hl.exec_cmd([[${devTerminal}]])
                  hl.exec_cmd([[${configureGtk}]])
                end'')
            ];
          };

          # https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
          workspace_rule = map (s: s.workspace_rule) specialWorkspaces;

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
          window_rule =
            [
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
            ]
            ++ map (c: {
              match.class = "^(${c})$";
              float = true;
            })
            floatClasses
            ++ [
              {
                match = {
                  class = "^Zoom$";
                  title = "Meeting chat";
                };
                float = true;
                move = "100%-w-20 30%";
                size = zoomSize;
              }
              {
                match = {
                  class = "^Zoom$";
                  title = "Webinar chat";
                };
                float = true;
                move = "100%-w-20 30%";
                size = zoomSize;
              }
              {
                match = {
                  class = "^Zoom$";
                  title = "^Participants.*$";
                };
                float = true;
                move = "100%-w-20 30%";
                size = zoomSize;
              }
              {
                match.class = "^(pavucontrol)$";
                float = true;
                size = "(monitor_w*0.60) (monitor_h*0.60)";
                center = true;
              }
            ]
            ++ map (s: s.window_rule) specialWorkspaces;
        };
      };
    };
  }
