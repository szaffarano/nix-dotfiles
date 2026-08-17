{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.compositors.hyprland;
  mod = "SUPER";
  inherit (lib.generators) mkLuaInline;

  # `hl.bind(keys, dispatcher [, opts])`
  # `disp` is raw Lua (an `hl.dsp.*(...)` expression).
  mkBind = keys: disp: {
    _args = [keys (mkLuaInline disp)];
  };
  mkBindOpts = keys: disp: opts: {
    _args = [keys (mkLuaInline disp) opts];
  };
  mkExec = keys: cmd: mkBind keys ''hl.dsp.exec_cmd("${cmd}")'';

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
      wayland.windowManager.hyprland.settings.bind =
        [
          # Mouse move/resize (was bindm)
          (mkBindOpts "${mod} + mouse:272" "hl.dsp.window.drag()" {mouse = true;})
          (mkBindOpts "${mod} + mouse:273" "hl.dsp.window.resize()" {mouse = true;})

          # Volume / brightness (was bindel: locked + repeating)
          (mkBindOpts "XF86AudioRaiseVolume" ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")'' {
            locked = true;
            repeating = true;
          })
          (mkBindOpts "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")'' {
            locked = true;
            repeating = true;
          })
          (mkBindOpts "XF86AudioMute" ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'' {
            locked = true;
          })
          (mkBindOpts "XF86MonBrightnessUp" ''hl.dsp.exec_cmd("brightnessctl set +5%")'' {
            locked = true;
            repeating = true;
          })
          (mkBindOpts "XF86MonBrightnessDown" ''hl.dsp.exec_cmd("brightnessctl set 5%-")'' {
            locked = true;
            repeating = true;
          })

          # Core binds
          (mkBind "${mod} + Return" ''hl.dsp.exec_cmd(${builtins.toJSON config.home.sessionVariables.TERMINAL})'')
          (mkBind "${mod} + SHIFT + Q" "hl.dsp.window.close()")

          (mkExec "${mod} + CTRL + SHIFT + BackSpace" "systemctl suspend")
          (mkBind "${mod} + CTRL + BackSpace" ''hl.dsp.exec_cmd(${builtins.toJSON (lib.getExe pkgs.hyprlock)})'')

          (mkBind "${mod} + f" "hl.dsp.window.fullscreen(0)")
          (mkBind "${mod} + SHIFT + f" "hl.dsp.window.fullscreen(1)")
          (mkBind "${mod} + space" ''hl.dsp.window.float({ action = "toggle" })'')
          (mkBind "${mod} + s" ''hl.dsp.layout("togglesplit")'')

          (mkBind "${mod} + minus" ''hl.dsp.layout("splitratio -0.25")'')
          (mkBind "${mod} + SHIFT + minus" ''hl.dsp.layout("splitratio -0.3333333")'')
          (mkBind "${mod} + equal" ''hl.dsp.layout("splitratio 0.25")'')
          (mkBind "${mod} + SHIFT + equal" ''hl.dsp.layout("splitratio 0.3333333")'')

          (mkBind "${mod} + g" "hl.dsp.group.toggle()")
          (mkBind "${mod} + CTRL + g" "hl.dsp.group.lock_active()")
          (mkBind "${mod} + CTRL + l" "hl.dsp.group.next()")
          (mkBind "${mod} + CTRL + h" "hl.dsp.group.prev()")
          (mkBind "${mod} + SHIFT + g" ''hl.dsp.window.move({ out_of_group = true })'')

          (mkExec "XF86AudioPlay" "playerctl play-pause")
          (mkExec "XF86AudioPause" "playerctl play-pause")
          (mkExec "XF86AudioNext" "playerctl next")
          (mkExec "XF86AudioPrev" "playerctl previous")

          (mkBind "${mod} + o" ''hl.dsp.workspace.toggle_special("orgmode")'')
          (mkBind "${mod} + t" ''hl.dsp.workspace.toggle_special("hackernews")'')
          (mkBind "${mod} + m" ''hl.dsp.workspace.toggle_special("musicPlayer")'')
          (mkBind "${mod} + p" ''hl.dsp.workspace.toggle_special("slack")'')
          (mkBind "${mod} + CTRL + p" ''hl.dsp.workspace.toggle_special("temporis")'')
          (mkBind "${mod} + SHIFT + t" ''hl.dsp.workspace.toggle_special("telegram")'')
        ]
        ++ (map (n: mkBind "${mod} + ${n}" ''hl.dsp.focus({ workspace = "name:${n}" })'') workspaces)
        ++ (map (n: mkBind "${mod} + SHIFT + ${n}" ''hl.dsp.window.move({ workspace = "name:${n}", silent = true })'') workspaces)
        ++ (mapAttrsToList (key: direction: mkBind "${mod} + ${key}" ''hl.dsp.focus({ direction = "${direction}" })'') directions)
        ++ (mapAttrsToList (key: direction: mkBind "${mod} + SHIFT + ${key}" ''hl.dsp.window.swap({ direction = "${direction}" })'') directions)
        # movewindoworgroup: move window in a direction, merging into a group if present.
        ++ (mapAttrsToList (key: direction: mkBind "${mod} + ALT + ${key}" ''hl.dsp.window.move({ direction = "${direction}", group_aware = true })'') directions)
        ++ (optionals config.desktop.wayland.swaync.enable (
          let
            swayNcClient = "${pkgs.swaynotificationcenter}/bin/swaync-client";
          in [
            (mkExec "CTRL + ALT + SPACE" "${swayNcClient} --hide-latest")
            (mkExec "CTRL + SHIFT + SPACE" "${swayNcClient} --close-all")
          ]
        ))
        ++ (optionals config.desktop.tools.keepassxc.enable (
          let
            passwordManager = "${pkgs.keepassxc}/bin/keepassxc";
          in [
            (mkExec "${mod} + SHIFT + w" passwordManager)
          ]
        ))
        ++ (optionals config.services.mako.enable (
          let
            makoctl = "${config.services.mako.package}/bin/makoctl";
          in [
            (mkExec "${mod} + w" "${makoctl} dismiss")
          ]
        ));
    };
  }
