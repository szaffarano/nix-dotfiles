{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.compositors.hyprland;
  workspaces = [
    "0"
    "1"
    "2"
    "3"
    "4"
    "5"
    "6"
    "7"
    "8"
    "9"
    "F1"
    "F2"
    "F3"
    "F4"
    "F5"
    "F6"
    "F7"
    "F8"
    "F9"
    "F10"
    "F11"
    "F12"
  ];
  directions = rec {
    left = "l";
    right = "r";
    up = "u";
    down = "d";
    h = left;
    l = right;
    k = up;
    j = down;
  };
in
  with lib; {
    config = mkIf cfg.enable {
      wayland.windowManager.hyprland.settings = {
        bindm = [
          "SUPER,mouse:272,movewindow"
          "SUPER,mouse:273,resizewindow"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ];

        bind =
          [
            "$mod, Return, exec,$terminal"
            "$mod_SHIFT, Q, killactive"

            "$mod_CTRL_SHIFT, BackSpace, exec, systemctl suspend"
            "$mod_CTRL, BackSpace, exec, ${lib.getExe pkgs.hyprlock}"

            "$mod,f,fullscreen,0"
            "$mod_SHIFT,f,fullscreen,1"
            "$mod,space,togglefloating"
            "$mod,s,layoutmsg,togglesplit"

            "$mod,minus,layoutmsg,splitratio -0.25"
            "$mod_SHIFT,minus,layoutmsg,splitratio -0.3333333"

            "$mod,equal,layoutmsg,splitratio 0.25"
            "$mod_SHIFT,equal,layoutmsg,splitratio 0.3333333"

            "$mod,g,togglegroup"
            "$mod_CTRL,g,lockactivegroup,toggle"
            "$mod_CTRL,l,changegroupactive,f"
            "$mod_CTRL,h,changegroupactive,b"
            "$mod_SHIFT,g,moveoutofgroup"

            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPause, exec, playerctl play-pause"
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPrev, exec, playerctl previous"

            "$mod, o, togglespecialworkspace, orgmode"
            "$mod, t, togglespecialworkspace, hackernews"
            "$mod, m, togglespecialworkspace, musicPlayer"
            "$mod, p, togglespecialworkspace, slack"
            "$mod_CTRL, p, togglespecialworkspace, temporis"
            "$mod_SHIFT, t, togglespecialworkspace, telegram"
          ]
          ++ (map (n: "$mod,${n},workspace,name:${n}") workspaces)
          ++ (map (n: "$modSHIFT,${n},movetoworkspacesilent,name:${n}") workspaces)
          ++ (mapAttrsToList (key: direction: "$mod,${key},movefocus,${direction}") directions)
          ++ (mapAttrsToList (key: direction: "$mod_SHIFT,${key},swapwindow,${direction}") directions)
          ++ (mapAttrsToList (key: direction: "$mod_ALT,${key},movewindoworgroup,${direction}") directions)
          ++ (optionals config.desktop.wayland.swaync.enable (
            let
              swayNcClient = "${pkgs.swaynotificationcenter}/bin/swaync-client";
            in [
              "CTRL_ALT,SPACE,exec, ${swayNcClient} --hide-latest"
              "CTRL_SHIFT,SPACE,exec, ${swayNcClient} --close-all"
            ]
          ))
          ++ (optionals config.desktop.tools.keepassxc.enable (
            let
              passwordManager = "${pkgs.keepassxc}/bin/keepassxc";
            in ["$mod_SHIFT,w,exec,${passwordManager}"]
          ))
          ++ (optionals config.services.mako.enable (
            let
              makoctl = "${config.services.mako.package}/bin/makoctl";
            in ["$mod,w,exec,${makoctl} dismiss"]
          ));
      };
    };
  }
