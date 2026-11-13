{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.desktop.xorg.compositors.i3.enable {
    xsession.windowManager.i3.config.keybindings = let
      terminal = config.home.sessionVariables.TERMINAL;
      modifier = config.xsession.windowManager.i3.config.modifier;

      i3msg = "${config.xsession.windowManager.i3.package}/bin/i3-msg";
      jq = lib.getExe pkgs.jq;

      lockCmd = "${pkgs.i3lock-color}/bin/i3lock-color --color ${config.colorScheme.palette.base00}";

      # Launch-or-toggle a named (instance) scratchpad with pure i3 + jq, no xdotool.
      scratch = name: cmd:
        pkgs.writeShellScript "i3-scratch-${name}" ''
          if ${i3msg} -t get_tree | ${jq} -e '[recurse(.nodes[]?,.floating_nodes[]?) | .window_properties? // empty | select(.instance == "${name}")] | length > 0' >/dev/null; then
            ${i3msg} '[instance="${name}"] scratchpad show'
          else
            exec ${cmd}
          fi
        '';

      hackernews = scratch "hnMode" ''${terminal} --class hnMode -e ${lib.getExe pkgs.hackernews-tui}'';
      musicPlayer = scratch "musicPlayer" ''${terminal} --class musicPlayer -e ${config.terminal.cli.spotify.exe}'';
      orgMode = scratch "orgMode" ''${terminal} --class orgMode -e nvim +Agenda'';
      termScratch = scratch "termScratch" ''${terminal} --class termScratch'';
      passwordManager = lib.getExe pkgs.keepassxc;
    in {
      "${modifier}+Return" = "exec ${terminal}";
      "${modifier}+Shift+q" = "kill";
      "${modifier}+Shift+P" = "exec ${terminal} --class floating-terminal -e btop";

      "${modifier}+Shift+w" = "exec ${passwordManager}";

      "${modifier}+h" = "focus left";
      "${modifier}+j" = "focus down";
      "${modifier}+k" = "focus up";
      "${modifier}+l" = "focus right";

      "${modifier}+Left" = "focus left";
      "${modifier}+Down" = "focus down";
      "${modifier}+Up" = "focus up";
      "${modifier}+Right" = "focus right";

      "${modifier}+Shift+h" = "move left";
      "${modifier}+Shift+j" = "move down";
      "${modifier}+Shift+k" = "move up";
      "${modifier}+Shift+l" = "move right";

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
      "${modifier}+Ctrl+BackSpace" = "exec ${lockCmd}";

      "${modifier}+r" = "mode resize";

      "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
      "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioPlay" = "exec playerctl play-pause";
      "XF86AudioPause" = "exec playerctl pause";
      "XF86AudioNext" = "exec playerctl next";
      "XF86AudioPrev" = "exec playerctl previous";

      "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
      "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";

      "${modifier}+Control+Left" = "move workspace to output left";
      "${modifier}+Control+Right" = "move workspace to output right";

      "${modifier}+Control+Mod1+Left" = "move container to output left";
      "${modifier}+Control+Mod1+Right" = "move container to output right";

      "${modifier}+minus" = "scratchpad show";
      "${modifier}+Shift+minus" = "move scratchpad";

      "${modifier}+m" = "exec ${musicPlayer}";
      "${modifier}+o" = "exec ${orgMode}";
      "${modifier}+t" = "exec ${hackernews}";
      "${modifier}+grave" = "exec ${termScratch}";
      "${modifier}+Shift+t" = ''[class="TelegramDesktop"] scratchpad show'';
      "${modifier}+Control+p" = ''[class="temporis"] scratchpad show'';
      "${modifier}+p" = ''[class="Slack"] scratchpad show'';
    };
  };
}
