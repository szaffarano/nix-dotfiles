{ config, pkgs, lib, ... }:
let
  fontConf = {
    names = [ "JetBrains Mono" "DejaVuSansMono" "FontAwesome 6 Free" ];
    style = "Bold Semi-Condensed";
    size = 12.0;
  };
in {
  imports = [ ./i3status-rs.nix ./gtk.nix ];

  home.packages = with pkgs; [ networkmanagerapplet ];
  programs.zsh.profileExtra = ''
    export XDG_CURRENT_DESKTOP="sway";
    export XDG_DATA_DIRS="$HOME/.nix-profile/share:$HOME/.local/share:/usr/local/share:/usr/share"
    export PATH="$PATH:$HOME/.nix-profile/bin"
  '';

  wayland.windowManager.sway = let
    rofiCmd = "${pkgs.rofi-wayland}/bin/rofi";
    ncspotCmd = "${config.programs.ncspot.package}/bin/ncspot";
    lockCmd = lib.concatStrings [
      "swaylock "
      " --screenshots"
      " --clock"
      " --indicator"
      " --indicator-radius 60"
      " --indicator-thickness 7"
      " --effect-blur 7x5"
      " --effect-vignette 0.5:0.5"
      " --ring-color bb00cc"
      " --key-hl-color 880033"
      " -K"
      " --line-color 00000000"
      " --inside-color 00000088"
      " --separator-color 00000000"
      " --grace 2"
      " --fade-in 0.2 &"
    ];
  in {
    enable = true;
    package = null;
    swaynag.enable = true;

    extraConfigEarly = "workspace 1";
    config = {
      modifier = "Mod4";
      terminal = "foot";
      menu = "${rofiCmd} -show drun";

      fonts = fontConf;
      workspaceAutoBackAndForth = true;

      window = {
        titlebar = false;
        hideEdgeBorders = "both";
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
        { command = "${pkgs.keepassxc}/bin/keepassxc"; }
        { command = "${pkgs.mako}/bin/mako"; }
        { command = "${pkgs.copyq}/bin/copyq"; }
        { command = "${pkgs.kanshi}/bin/kanshi"; }
        { command = "${pkgs.speedcrunch}/bin/speedcrunch"; }
        { command = "${pkgs.foot}/bin/foot --title main-term"; }
        { command = "${pkgs.foot}/bin/foot --title ncspot ${ncspotCmd}"; }
        {
          command = ''
            ${pkgs.swayidle}/bin/swayidle -w \
               timeout 300 '${lockCmd}' \
               timeout 600 'swaymsg "output * dpms off"' \
               resume 'swaymsg "output * dpms on"' \
               before-sleep '${lockCmd}'
          '';
        }
        { command = "${pkgs.firefox}/bin/firefox"; }
      ];

      assigns = {
        "1" = [{ app_id = "firefox"; }];
        "2" = [{ class = "jetbrains-idea.*"; }];
        "3" = [{
          app_id = "foot";
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

      bars = [{
        statusCommand =
          "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
        command = "swaybar";
        position = "bottom";
        fonts = fontConf;
        extraConfig = "height 32";
        trayOutput = "*";
      }];

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
          criteria = {
            app_id = "foot";
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
        "${mod}+q" = "exec --no-startup-id ${rofiCmd} -show window";
        "${mod}+F2" = "exec --no-startup-id ${rofiCmd} -show run";

        "${mod}+Shift+w" = "exec ${pkgs.keepassxc}/bin/keepassxc";

        "Print" =
          "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save area - | ${pkgs.swappy}/bin/swappy -f -";
        "Shift+Print" =
          "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save screen";

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
          exec --no-startup-id ${rofiCmd} -show menu -modi "menu:rofi-power-menu"
        '';
        "${mod}+Ctrl+Shift+BackSpace" = "exec systemctl suspend";
        "${mod}+Ctrl+BackSpace" = "exec ${lockCmd}";

        "${mod}+r" = "mode resize";

        "Ctrl+Alt+v" = "exec ${pkgs.copyq}/bin/copyq toggle";

        "Ctrl+Space" = "exec ${pkgs.mako}/bin/makoctl dismiss";
        "Ctrl+Shift+Space" = "exec ${pkgs.mako}/bin/makoctl dismiss -a";

        "XF86AudioMute" =
          "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioRaiseVolume" =
          "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" =
          "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

        "${mod}+Control_L+Left" = "move workspace to output left";
        "${mod}+Control_L+Right" = "move workspace to output left";

        "${mod}+minus" = "scratchpad show";
        "${mod}+Shift+minus" = "move scratchpad";

        "${mod}+Shift+s" = ''[app_id="org.speedcrunch."] scratchpad show'';
        "${mod}+m" = ''[app_id="foot" title="ncspot"] scratchpad show'';
        "${mod}+Shift+m" = ''
          exec ${pkgs.foot}/bin/foot --title ncspot ${ncspotCmd}; [app_id="foot" title="ncspot"] scratchpad show'';
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

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font Mono:size=13";
        dpi-aware = "yes";
      };
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    cycle = true;
    terminal = "${pkgs.foot}/bin/foot";
    theme = "catppuccin-mocha";
    plugins = with pkgs; [
      rofi-bluetooth
      rofi-calc
      rofi-emoji
      rofi-power-menu
      rofi-pulse-select
    ];
    extraConfig = {
      modi = "run,drun,ssh,combi,keys,filebrowser";
      icon-theme = "Oranchelo";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = "   Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };
  };

  programs.zathura = {
    enable = true;
    options.selection-clipboard = "clipboard";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "text/html" = "firefox.desktop";
    };
  };
  xdg.dataFile."applications/mimeapps.list".force = true;
  xdg.configFile."mimeapps.list".force = true;

  services.kanshi = {
    enable = true;
    systemdTarget = "";
    profiles = {
      undocked = {
        outputs = [{
          criteria = "eDP-1";
          status = "enable";
        }];
      };
      docked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "HDMI-A-1";
            status = "enable";
          }
        ];
      };
    };
  };
}
