{
  theme,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.compositors.sway;
in
  with lib; {
    options.desktop.wayland.compositors.sway.enable = mkEnableOption "sway";

    imports = [
      ./colors.nix
      ./fish.nix
      ./floating-criteria.nix
      ./keybindings.nix
      ./window-commands.nix
      ./zsh.nix
    ];

    config = let
      terminal = config.home.sessionVariables.TERMINAL;
    in
      mkIf cfg.enable {
        desktop = {
          wayland = {
            swayidle.enable = true;
            swaylock.enable = true;
            swaync.enable = true;
          };
        };

        wayland.windowManager.sway = {
          enable = true;
          swaynag.enable = true;

          extraConfigEarly = ''
            workspace 1
          '';

          config = {
            modifier = "Mod4";
            workspaceAutoBackAndForth = true;
            fonts = with config.fontProfiles.monospace; {
              names = [name];
              size = sizeAsInt * 0.9;
            };

            window = {
              titlebar = false;
            };

            bars = lib.optionals (! config.desktop.wayland.waybar.enable) [
              {
                id = "main";
                command = "swaybar";
                extraConfig = ''
                  icon_theme ${theme.gtk.icon-theme}
                '';
                fonts = with config.fontProfiles.monospace; {
                  names = [name];
                  size = sizeAsInt * 0.9;
                };
                position = "bottom";
                statusCommand = "while date +'%Y-%m-%d %X'; do sleep 1; done";
                trayOutput = "*";
              }
            ];

            startup = let
              configure-gtk = lib.getExe pkgs.configure-gtk;
              tmux = lib.getExe pkgs.tmux;
              fish = lib.getExe pkgs.fish;
            in [
              {
                command = ''${terminal} -a dev-terminal ${fish} -c "${tmux} attach -s random || ${tmux} new -s random"'';
              }
              {
                command = ''
                  ${configure-gtk} \
                      '${theme.gtk.theme}' \
                      '${theme.gtk.cursor-theme}' \
                      '${theme.gtk.icon-theme}' \
                      '${config.fontProfiles.regular.name}' \
                      '${config.fontProfiles.monospace.name}'
                '';
                always = true;
              }
            ];

            assigns = {
              "1" = [{app_id = "firefox";}];
              "2" = [{class = "jetbrains-idea.*";}];
              "3" = [{app_id = "dev-terminal";}];
            };

            output = {
              HDMI-A-1 = {
                scale = "1";
              };
              DP-1 = {
                scale = "1.5";
              };
              DP-2 = {
                scale = "1.5";
              };
              eDP-1 = {
                scale = "1";
              };
            };

            seat = {
              "*" = {
                xcursor_theme = theme.gtk.cursor-theme;
              };
            };

            input = {
              "type:keyboard" = {
                repeat_delay = "250";
                repeat_rate = "25";
                xkb_layout = "us,us";
                xkb_variant = "altgr-intl,dvorak";
                xkb_options = "grp:rctrl_toggle";
              };
              "type:touchpad" = {
                click_method = "clickfinger";
                tap = "enabled";
                dwt = "enabled";
              };
              "type:pointer" = {
                accel_profile = "flat";
                pointer_accel = "0.5";
              };
            };

            modes = {
              resize = {
                "h" = "resize shrink width";
                "l" = "resize grow width";
                "j" = "resize shrink height";
                "k" = "resize grow height";
                Return = "mode default";
                Escape = "mode default";
              };
            };
          };
        };

        systemd.user.targets.sway-session-shutdown = {
          Unit = {
            Description = "Shutdown running sway session";
            DefaultDependencies = "no";
            StopWhenUnneeded = "true";

            Conflicts = [
              "graphical-session.target"
              "graphical-session-pre.target"
              "sway-session.target"
            ];
            After = [
              "graphical-session.target"
              "graphical-session-pre.target"
              "sway-session.target"
            ];
          };
        };
      };
  }
