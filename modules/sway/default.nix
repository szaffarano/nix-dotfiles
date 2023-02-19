_:
{ config, lib, pkgs, ... }: {
  imports =
    [ ./i3status-rs.nix ./rofi.nix ./kanshi.nix ./zathura.nix ./waybar ];

  options.sway.enable = lib.mkEnableOption "sway";

  config = let
    terminalCmd = "kitty";
    fontConf = {
      names = [
        "Iosevka Extended"
        "JetBrains Mono"
        "DejaVuSansMono"
        "FontAwesome 6 Free"
      ];
      style = "Bold Semi-Condensed";
      size = 12.0;
    };
    lockCmd = lib.concatStrings [
      "swaylock "
      " -S -F -f"
      " --indicator"
      " --indicator-radius 60"
      " -K"
      " --grace 2"
      " --effect-blur 5x8"
      " --fade-in 0.5"
    ];

  in lib.mkIf config.sway.enable {

    i3status-rs = {
      enable = true;
      fonts = fontConf;
    };
    waybar.enable = false;

    gtk.config.enable = true;
    kitty.enable = true;
    rofi.enable = true;
    zathura.enable = true;
    kanshi.enable = true;

    home.packages = with pkgs; [
      kanshi
      xwayland
      mako
      networkmanagerapplet
      swayidle
      wl-clipboard
      wlr-randr
      wtype
    ];

    wayland.windowManager.sway = {
      enable = true;
      package = null;
      swaynag.enable = true;

      extraConfigEarly = "workspace 1";

      config = {
        modifier = "Mod4";
        terminal = terminalCmd;
        fonts = fontConf;
        workspaceAutoBackAndForth = true;

        window = {
          titlebar = false;
        };

        floating.criteria = [
          { app_id = "^pavucontrol$"; }
          { app_id = "com.github.hluk.copyq"; }
          { app_id = "nm-connection-editor"; }
          { app_id = "blueberry.py"; }
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
          { class = "flameshot"; }
        ];

        startup = [
          { command = "keepassxc"; }
          { command = "mako"; }
          { command = "copyq"; }
          { command = "kanshi"; }
          { command = "speedcrunch"; }
          { command = "kitty --title main-term"; }
          { command = "kitty --title ncspot ncspot"; }
          {
            command = ''
              swayidle -w \
                 timeout 300 '${lockCmd}' \
                 timeout 600 'swaymsg "output * dpms off"' \
                 resume 'swaymsg "output * dpms on"' \
                 before-sleep '${lockCmd}'
            '';
          }
          { command = "firefox"; }
        ];

        assigns = {
          "1" = [{ app_id = "firefox"; }];
          "2" = [{ class = "jetbrains-idea.*"; }];
          "3" = [{
            app_id = "kitty";
            title = "main-term";
          }];
        };

        input = {
          "type:keyboard" = {
            xkb_layout = "us,us";
            xkb_variant = "altgr-intl,dvorak-intl";
            xkb_options = "grp:rctrl_toggle";
          };
          "type:touchpad" = {
            click_method = "clickfinger";
            tap = "enabled";
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
            criteria.class = "Slack";
          }
          {
            command = "move to scratchpad";
            criteria = {
              app_id = "kitty";
              title = "ncspot";
            };
          }
        ];

        keybindings = let
          mod = config.wayland.windowManager.sway.config.modifier;
          inherit (config.wayland.windowManager.sway.config)
            left down up right menu terminal;
        in lib.mkOptionDefault {
          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Shift+q" = "kill";
          "${mod}+d" = "exec ${menu}";
          "${mod}+q" = "exec --no-startup-id rofi -show window";
          "${mod}+F2" = "exec --no-startup-id rofi -show run";

          "${mod}+Shift+w" = "exec ${pkgs.keepassxc}/bin/keepassxc";

          "Print" = "exec grimshot save area - | swappy -f -";
          "Shift+Print" = "exec grimshot save screen";

          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";

          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";

          "${mod}+space" = "focus mode_toggle";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

          "${mod}+backslash" = "split h";
          "${mod}+v" = "split v";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";
          "${mod}+a" = "focus parent";
          "${mod}+c" = "focus child";

          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+r" = "restart";
          "${mod}+BackSpace" = ''
            exec --no-startup-id rofi -show menu -modi "menu:rofi-power-menu"
          '';
          "${mod}+Ctrl+Shift+BackSpace" = "exec systemctl suspend";
          "${mod}+Ctrl+BackSpace" = "exec ${lockCmd}";

          "${mod}+r" = "mode resize";

          "Ctrl+Alt+v" = "exec copyq toggle";

          "Ctrl+Space" = "exec makoctl dismiss";
          "Ctrl+Shift+Space" = "exec makoctl dismiss -a";

          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioRaiseVolume" =
            "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" =
            "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPause" = "exec playerctl pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";

          "${mod}+Control_L+Left" = "move workspace to output left";
          "${mod}+Control_L+Right" = "move workspace to output left";

          "${mod}+minus" = "scratchpad show";
          "${mod}+Shift+minus" = "move scratchpad";

          "${mod}+Shift+s" = ''[app_id="org.speedcrunch."] scratchpad show'';
          "${mod}+m" = ''[app_id="kitty" title="ncspot"] scratchpad show'';
          "${mod}+Shift+t" =
            ''[app_id="org.telegram.desktop"] scratchpad show'';
          "${mod}+p" = ''[class="Slack"] scratchpad show'';
          "${mod}+Shift+m" = ''
            exec kitty --title ncspot ncspot; [app_id="kitty" title="ncspot"] scratchpad show
          '';
        };

        modes = {
          "system: [l]ogout [p]oweroff [r]eboot [s]uspend" = {
            r = "exec systemctl reboot";
            p = "exec systemctl poweroff";
            l = "exit";
            s = "exec systemctl suspend";
            Return = "mode default";
            Escape = "mode default";
          };
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

    programs.zsh.profileExtra = ''
      export XDG_CURRENT_DESKTOP="sway";
      export XDG_DATA_DIRS="$HOME/.nix-profile/share:$HOME/.local/share:/usr/local/share:/usr/share"
      export PATH="$PATH:$HOME/.nix-profile/bin"
    '';
  };
}
