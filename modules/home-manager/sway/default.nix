_:
{ config, lib, pkgs, ... }: {
  imports = [
    ./i3status-rs.nix
    ./rofi.nix
    ./kanshi.nix
    ./zathura.nix
    ./waybar
    ./swaync
  ];

  options.sway.enable = lib.mkEnableOption "sway";

  config =
    let
      terminalCmd = "kitty";
      fontConf = {
        names = [ "JetBrainsMono Nerd Font" "Ubuntu" ];
        style = "";
        size = 12.0;
      };
      lockCmd = "swaylock --grace 5 -f";
      lockCmdBeforeSleep = "swaylock --grace 5 -f";

      # arbitrary delay to wait until swaybar starts, otherwhise tray icons are not shown
      startupCommandDellay = "5";

      catppuccin = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "i3";
        rev = "c89098f";
        sha256 = "sha256-6Cvsmdl3OILz1vZovyBIuuSpm207I3W0dmUGowR9Ugk=";
      };
    in
    lib.mkIf config.sway.enable {

      xdg.configFile."sway/themes" = { source = "${catppuccin}/themes"; };
      xdg.configFile."swaylock/config".source = ./swaylock;

      i3status-rs = {
        enable = false;
        fonts = fontConf;
      };
      waybar.enable = true;

      gtk.config.enable = true;
      kitty.enable = true;
      rofi.enable = true;
      zathura.enable = true;
      kanshi.enable = true;
      swaync.enable = true;

      home.packages = with pkgs; [
        kanshi
        libnotify
        networkmanagerapplet
        wl-clipboard
        wlr-randr
        wtype
      ];

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = "org.pwmt.zathura.desktop";

          "application/x-extension-htm" = "firefox.desktop";
          "application/x-extension-html" = "firefox.desktop";
          "application/x-extension-shtml" = "firefox.desktop";
          "application/x-extension-xht" = "firefox.desktop";
          "application/x-extension-xhtml" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";

          "text/html" = "firefox.desktop";

          "x-scheme-handler/chrome" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
        };
      };
      xdg.dataFile."applications/mimeapps.list".force = true;
      xdg.configFile."mimeapps.list".force = true;

      wayland.windowManager.sway = {
        enable = true;
        package = null;
        swaynag.enable = true;

        extraConfigEarly = ''
          include themes/catppuccin-mocha
          workspace 1
        '';

        config = {
          modifier = "Mod4";
          terminal = terminalCmd;
          fonts = fontConf;
          workspaceAutoBackAndForth = true;

          window = { titlebar = false; };

          floating.criteria = [
            { app_id = "^pavucontrol$"; }
            { app_id = "zenity"; }
            { app_id = "com.github.hluk.copyq"; }
            { app_id = "nm-connection-editor"; }
            { app_id = "blueberry.py"; }
            { app_id = "transmission-qt"; }
            {
              app_id = "kitty";
              title = "floating-terminal";
            }
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

          startup = [
            {
              command =
                "gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'";
              always = true;
            }
            {
              command =
                "gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'";
              always = true;
            }
            {
              command =
                "gsettings set org.gnome.desktop.interface icon-theme 'Papirus'";
              always = true;
            }
            {
              command =
                "gsettings set org.gnome.desktop.interface font-name 'Liberation Sans 11'";
              always = true;
            }
            {
              command =
                "gsettings set org.gnome.desktop.interface monospace-font-name 'FiraCode Nerd Font Mono 11'";
              always = true;
            }
            { command = "swaync"; }
            { command = "kanshi"; }
            { command = "speedcrunch"; }
            { command = "'sleep ${startupCommandDellay} && keepassxc'"; }
            { command = "'sleep ${startupCommandDellay} && pasystray'"; }
            { command = "'sleep ${startupCommandDellay} && nm-applet --indicator'"; }
            { command = "'sleep ${startupCommandDellay} && copyq'"; }
            { command = "'sleep ${startupCommandDellay} && slack -g error'"; }
            { command = "kitty --title main-term"; }
            { command = "kitty --title ncspot ncspot"; }
            {
              command = ''
                swayidle -w \
                   timeout 300 '${lockCmd}' \
                   timeout 1800 'swaymsg "output * dpms off"' \
                   resume 'swaymsg "output * dpms on"' \
                   before-sleep '${lockCmdBeforeSleep}'
              '';
            }
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
              repeat_delay = "250";
              repeat_rate = "25";
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

          keybindings =
            let
              mod = config.wayland.windowManager.sway.config.modifier;
              inherit (config.wayland.windowManager.sway.config)
                left down up right menu terminal;
            in
            lib.mkOptionDefault {
              "${mod}+Return" = "exec ${terminal}";
              "${mod}+Shift+q" = "kill";
              "${mod}+Shift+P" = "exec ${terminal} --title floating-terminal htop";
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

              "Ctrl+Alt+Space" = "exec swaync-client --hide-latest";
              "Ctrl+Shift+Space" = "exec swaync-client --close-all";

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

      programs.zsh.profileExtra = ''
        export XDG_CURRENT_DESKTOP="sway";
        export XDG_DATA_DIRS="$HOME/.nix-profile/share:$HOME/.local/share:/usr/local/share:/usr/share"
        export PATH="$PATH:$HOME/.nix-profile/bin"
        export NO_AT_BRIDGE=1
      '';

      programs.zsh.loginExtra = ''
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
          exec ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel sway \
            > ~/.cache/sway.log 2>~/.cache/sway.err.log
        fi
      '';
    };
}
