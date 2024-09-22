{ config
, lib
, pkgs
, ...
}:
let
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
with lib;
{
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
      ];

      bind =
        let
          toggleScratchpad = lib.getExe pkgs.toggle-hyprland-scratchpad;
        in
        [
          ''$mod_CTRL, s, exec, sh -c "[ $(hyprctl monitors all -j | jq '.[] | select(.name == "eDP-1").disabled') = 'false' ]  && hyprctl keyword monitor eDP-1,disable,1 || hyprctl keyword monitor eDP-1,enable,1"''

          "$mod, Return, exec,$terminal"
          "$mod_SHIFT, Q, killactive"

          "$mod,f,fullscreen,0"
          "$mod_SHIFT,f,fullscreen,1"
          "$mod,space,togglefloating"
          "$mod,s,togglesplit"

          "$mod,minus,splitratio,-0.25"
          "$mod_SHIFT,minus,splitratio,-0.3333333"

          "$mod,equal,splitratio,0.25"
          "$mod_SHIFT,equal,splitratio,0.3333333"

          "$mod,g,togglegroup"
          "$mod,t,lockactivegroup,toggle"
          "$mod_CTRL,l,changegroupactive,f"
          "$mod_CTRL,h,changegroupactive,b"
          "$mod_SHIFT,g,moveoutofgroup"

          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"

          "$mod, o, exec, ${toggleScratchpad} wrap orgmode \"nvim '+Neorg index'\""
          "$mod, m, exec, ${toggleScratchpad} wrap musicPlayer ncspot"
          "$mod, p, togglespecialworkspace, Slack"
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
          in
          [
            "CTRL_ALT,SPACE,exec, ${swayNcClient} --hide-latest"
            "CTRL_SHIFT,SPACE,exec, ${swayNcClient} --close-all"
          ]
        ))
        ++ (optionals config.desktop.tools.keepassxc.enable (
          let
            passwordManager = "${pkgs.keepassxc}/bin/keepassxc";
          in
          [ "$mod_SHIFT,w,exec,${passwordManager}" ]
        ))
        ++ (optionals config.services.mako.enable (
          let
            makoctl = "${config.services.mako.package}/bin/makoctl";
          in
          [ "$mod,w,exec,${makoctl} dismiss" ]
        ))
        ++ (optionals config.programs.wofi.enable (
          let
            wofi = "${config.programs.wofi.package}/bin/wofi";
            wofiPowerMenu = "wofi-power-menu";
          in
          [
            "$mod,x,exec,${wofi} -S drun"
            "$mod,d,exec,${wofi} -S run"
            "$mod,backspace,exec,${wofiPowerMenu}"
          ]
        ));
    };
  };
}
