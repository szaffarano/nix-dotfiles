{
  config,
  lib,
  pkgs,
  ...
}: {
  config = let
    terminal = config.home.sessionVariables.TERMINAL;
  in {
    wayland.windowManager.sway.config.keybindings = let
      inherit
        (config.wayland.windowManager.sway.config)
        left
        down
        up
        right
        modifier
        ;
      hackernews = "${toggleScratchpad} 'hnMode' '${lib.getExe pkgs.hackernews-tui}'";
      lockScreen = lib.getExe pkgs.lock-screen;
      musicPlayer = "${toggleScratchpad} 'musicPlayer' '${config.terminal.cli.spotify.exe}'";
      orgMode = "${toggleScratchpad} 'orgMode' 'nvim +Agenda'";
      passwordManager = lib.getExe pkgs.keepassxc;
      swayNcClient = "${pkgs.swaynotificationcenter}/bin/swaync-client";
      toggleScratchpad = lib.getExe pkgs.toggle-sway-scratchpad;
    in {
      "${modifier}+Return" = "exec ${terminal}";
      "${modifier}+Shift+q" = "kill";
      "${modifier}+Shift+P" = "exec ${terminal} -a floating-terminal htop";

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
      "${modifier}+Ctrl+Shift+BackSpace" = "exec systemctl suspend";
      "${modifier}+Ctrl+BackSpace" = "exec ${lockScreen} 0";

      "${modifier}+r" = "mode resize";

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

      "${modifier}+m" = "exec ${musicPlayer}";
      "${modifier}+o" = "exec ${orgMode}";
      "${modifier}+t" = "exec ${hackernews}";
      "${modifier}+Shift+t" = ''[app_id="org.telegram.desktop"] scratchpad show'';
      "${modifier}+p" = ''[class="Slack"] scratchpad show'';
    };
  };
}
