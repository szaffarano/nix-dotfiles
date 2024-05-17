{ theme
, config
, lib
, pkgs
, ...
}:
let
  cfg = config.desktop.wayland.compositors.sway;
in
with lib;
{

  options.desktop.wayland.compositors.sway.enable = mkEnableOption "sway";

  config =
    let
      terminal = config.home.sessionVariables.TERMINAL;
      lockScreen = "${pkgs.lock-screen}/bin/lock-screen";
      toggleScratchpad = "${pkgs.toggle-sway-scratchpad}/bin/toggle-sway-scratchpad";
      wofi = "${pkgs.wofi}/bin/wofi";
      wofiPowerMenu = "wofi-power-menu";
      swayNcClient = "${pkgs.swaynotificationcenter}/bin/swaync-client";
      ncspot = "${pkgs.ncspot}/bin/ncspot";
      passwordManager = "${pkgs.keepassxc}/bin/keepassxc";

      musicPlayerCommand = "${toggleScratchpad} 'musicPlayer' '${ncspot}'";
      orgCommand = "${toggleScratchpad} 'orgMode' 'nvim +WikiIndex'";

      # TODO integrate with config.colorscheme
      catppuccin = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "i3";
        rev = "9c430d7";
        sha256 = "sha256-EHZ/D4PrFqwyTpfcst3+hSx6z4saVD1M9CfFqnWI6io=";
      };
      themeVars = readFile "${catppuccin}/themes/catppuccin-mocha";
    in
    mkIf cfg.enable {
      desktop = {
        wayland = {
          swayidle.enable = true;
          swaylock.enable = true;
          swaync.enable = true;
        };
      };

      # TODO: use global theme
      xdg.configFile."sway/themes" = {
        source = "${catppuccin}/themes";
      };

      wayland.windowManager.sway = {
        enable = true;
        package = null;
        swaynag.enable = true;

        extraConfigEarly =
          themeVars
          + ''
            # TODO it looks like the include stopped working and
            # the variables defined there are not expanded anymore
            # include themes/catppuccin-mocha
            workspace 1
          '';

        config = {
          modifier = "Mod4";
          workspaceAutoBackAndForth = true;
          fonts = {
            inherit (theme.sway.fonts) style size;
            names = [ theme.sway.fonts.name ];
          };

          window = {
            titlebar = false;
          };

          bars = lib.optionals config.programs.waybar.enable [ ];

          floating.criteria = [
            { app_id = "^pavucontrol$"; }
            { app_id = "zenity"; }
            { title = "as_toolbar"; }
            { title = "zoom"; }
            { title = "Settings"; }
            { title = "Zoom - Free Account"; }
            { title = "Firefox — Sharing Indicator"; }
            { app_id = "copyq"; }
            { app_id = "nm-connection-editor"; }
            { app_id = "blueberry.py"; }
            { app_id = "transmission-qt"; }
            { app_id = "floating-terminal"; }
            { class = "^Keybase$"; }
            { class = "^JetBrains Toolbox$"; }
            { title = "tracker - .*"; }
            { title = "nmtui-wifi-edit"; }
            {
              class = "jetbrains-idea-ce";
              title = "Welcome to IntelliJ IDEA";
            }
            {
              class = "jetbrains-datagrip";
              title = "Welcome to DataGrip";
            }
            {
              class = "jetbrains-idea";
              title = "win0";
            }
            {
              class = "Anki";
              title = "Profiles";
            }
            {
              class = "Anki";
              title = "Add";
            }
            {
              class = "Anki";
              title = "^Browse.*";
            }
            { app_id = "org.keepassxc.KeePassXC"; }
            { class = "Blueman-manager"; }
          ];

          startup =
            let
              configure-gtk = "${pkgs.configure-gtk}/bin/configure-gtk";
            in
            [
              {
                command = ''${terminal} start --class=dev-terminal zsh --login -c "tmux attach -t random || tmux new -s random"'';
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
            "1" = [{ app_id = "firefox"; }];
            "2" = [{ class = "jetbrains-idea.*"; }];
            "3" = [{ app_id = "dev-terminal"; }];
          };

          output = {
            # TODO stopped working, related to the theme
            # "*".bg = ''"$(${wallpaper})" fit'';

            HDMI-A-1 = {
              scale = "1";
            };
            DP-1 = {
              scale = "1.25";
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
              pointer_accel = "1";
            };
          };

          window.commands = [
            {
              command = "inhibit_idle fullscreen";
              criteria.app_id = "firefox";
            }
            {
              command = "move to scratchpad";
              criteria.app_id = "org.speedcrunch.";
            }
            {
              command = "move to scratchpad";
              criteria.app_id = "org.telegram.desktop";
            }
            {
              command = "move to scratchpad";
              criteria.app_id = "Slack";
            }
            {
              command = "move to scratchpad";
              criteria = {
                app_id = "musicPlayer";
              };
            }
            {
              command = "move to scratchpad";
              criteria = {
                app_id = "orgMode";
              };
            }
          ];

          keybindings =
            let
              inherit (config.wayland.windowManager.sway.config)
                left
                down
                up
                right
                modifier
                ;
            in
            lib.mkDefault {
              "${modifier}+Return" = "exec ${terminal}";
              "${modifier}+Shift+q" = "kill";
              "${modifier}+Shift+P" = "exec ${terminal} start --class=floating-terminal htop";
              "${modifier}+d" = "exec ${wofi} -S run";
              "${modifier}+x" = "exec ${wofi} -S drun";

              "${modifier}+Shift+w" = "exec ${passwordManager}";

              "${modifier}+${left}" = "focus left";
              "${modifier}+${down}" = "focus down";
              "${modifier}+${up}" = "focus up";
              "${modifier}+${right}" = "focus right";

              "${modifier}+Left" = "focus left";
              "${modifier}+Down" = "focus down";
              "${modifier}+Up" = "focus up";
              "${modifier}+Right" = "focus right";

              "${modifier}+Shift+${left}" = "move left";
              "${modifier}+Shift+${down}" = "move down";
              "${modifier}+Shift+${up}" = "move up";
              "${modifier}+Shift+${right}" = "move right";

              "${modifier}+space" = "focus mode_toggle";
              "${modifier}+Shift+space" = "floating toggle";

              "${modifier}+1" = "workspace number 1";
              "${modifier}+2" = "workspace number 2";
              "${modifier}+3" = "workspace number 3";
              "${modifier}+4" = "workspace number 4";
              "${modifier}+5" = "workspace number 5";
              "${modifier}+6" = "workspace number 6";
              "${modifier}+7" = "workspace number 7";
              "${modifier}+8" = "workspace number 8";
              "${modifier}+9" = "workspace number 9";
              "${modifier}+0" = "workspace number 10";

              "${modifier}+Shift+1" = "move container to workspace number 1";
              "${modifier}+Shift+2" = "move container to workspace number 2";
              "${modifier}+Shift+3" = "move container to workspace number 3";
              "${modifier}+Shift+4" = "move container to workspace number 4";
              "${modifier}+Shift+5" = "move container to workspace number 5";
              "${modifier}+Shift+6" = "move container to workspace number 6";
              "${modifier}+Shift+7" = "move container to workspace number 7";
              "${modifier}+Shift+8" = "move container to workspace number 8";
              "${modifier}+Shift+9" = "move container to workspace number 9";
              "${modifier}+Shift+0" = "move container to workspace number 10";

              "${modifier}+backslash" = "split h";
              "${modifier}+v" = "split v";
              "${modifier}+f" = "fullscreen toggle";
              "${modifier}+s" = "layout stacking";
              "${modifier}+w" = "layout tabbed";
              "${modifier}+e" = "layout toggle split";
              "${modifier}+a" = "focus parent";
              "${modifier}+c" = "focus child";

              "${modifier}+Shift+c" = "reload";
              "${modifier}+Shift+r" = "restart";
              "${modifier}+BackSpace" = "exec ${wofiPowerMenu}";
              "${modifier}+Ctrl+Shift+BackSpace" = "exec systemctl suspend";
              "${modifier}+Ctrl+BackSpace" = "exec ${lockScreen} 0";

              "${modifier}+r" = "mode resize";

              "Ctrl+Alt+v" = "exec copyq toggle";

              "Ctrl+Alt+Space" = "exec ${swayNcClient} --hide-latest";
              "Ctrl+Shift+Space" = "exec ${swayNcClient} --close-all";

              "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
              "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
              "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
              "XF86AudioPlay" = "exec playerctl play-pause";
              "XF86AudioPause" = "exec playerctl pause";
              "XF86AudioNext" = "exec playerctl next";
              "XF86AudioPrev" = "exec playerctl previous";

              "${modifier}+Control_L+Left" = "move workspace to output left";
              "${modifier}+Control_L+Right" = "move workspace to output left";

              "${modifier}+minus" = "scratchpad show";
              "${modifier}+Shift+minus" = "move scratchpad";

              "${modifier}+Shift+s" = ''[app_id="org.speedcrunch."] scratchpad show'';
              "${modifier}+m" = "exec ${musicPlayerCommand}";
              "${modifier}+o" = "exec ${orgCommand}";
              "${modifier}+Shift+t" = ''[app_id="org.telegram.desktop"] scratchpad show'';
              "${modifier}+p" = ''[app_id="Slack"] scratchpad show'';
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
          colors = {
            unfocused = {
              background = "$base";
              border = "$mauve";
              childBorder = "$mauve";
              indicator = "$rosewater";
              text = "$text";
            };
            focused = {
              background = "$base";
              border = "$pink";
              childBorder = "$pink";
              indicator = "$rosewater";
              text = "$pink";
            };
            focusedInactive = {
              background = "$base";
              border = "$mauve";
              childBorder = "$mauve";
              indicator = "$rosewater";
              text = "$text";
            };
            urgent = {
              background = "$base";
              border = "$peach";
              childBorder = "$peach";
              indicator = "$overlay0";
              text = "$peach";
            };
            placeholder = {
              background = "$base";
              border = "$overlay0";
              childBorder = "$overlay0";
              indicator = "$overlay0";
              text = "$text";
            };
            background = "$base";
          };
        };
      };

      programs.zsh.loginExtra = ''
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
          exec ${pkgs.sway}/bin/sway \
            > ~/.cache/sway.log 2>~/.cache/sway.err.log
        fi
      '';

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
