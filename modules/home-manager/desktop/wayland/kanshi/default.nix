# Data-driven multi-monitor management with kanshi.
#
# A single global `externals` registry (below) describes every display. From it
# this module generates all kanshi profiles (one per connected-set per cycle
# state, with scale-aware left-to-right positions) plus a `kanshi-switch` helper
# that drives manual switching. kanshi is the sole output authority on both Sway
# and Hyprland -- do NOT add native `monitor =` rules in the Hyprland config, as
# they race with kanshi on enable/disable and spawn phantom workspaces.
#
# Shortcuts (Sway + Hyprland):
#   Ctrl+Alt+Space  cycle layouts for the currently connected outputs
#                   (e.g. primary only -> both externals -> both + laptop ->
#                    laptop only -> back to start)
#   Ctrl+Alt+U      laptop-only (undocked)
#   Ctrl+Alt+R      reset to the default layout (primary external only)
#
# Hotplug default: when outputs are (dis)connected, kanshi auto-applies the
# first matching profile, which is always the "primary external only" layout.
#
# Adding a new monitor:
#   1. Add an entry to `externals` with its `criteria` (make + " " + model +
#      " " + serial, as reported by `wlr-randr --json` / `hyprctl monitors`),
#      a `mode`/`scale` referencing new options, and a unique `priority`
#      (1 = primary when several are connected).
#   2. Add matching `<id>Mode` / `<id>Scale` options below.
# Profiles, positions, the cycle order and runtime detection all update
# automatically. Max two externals at once is assumed.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.kanshi;

  laptop = "eDP-1";

  # Global monitor registry: every external display defined once as data.
  # kanshi matches by `criteria` on any machine; `priority` 1 = primary when
  # several are connected. Adding a new monitor = add an entry here (+ options).
  externals = [
    {
      id = "lg4k";
      criteria = "LG Electronics LG HDR 4K 301MAPNGQZ84";
      mode = cfg.lgMode;
      scale = cfg.lgScale;
      priority = 1;
    }
    {
      id = "asus";
      criteria = "ASUSTek COMPUTER INC ASUS VA24E LBLMTF309577";
      mode = cfg.asusMode;
      scale = cfg.asusScale;
      priority = 2;
    }
    {
      id = "lg23";
      criteria = "LG Electronics 23MP55 0x00001748";
      mode = cfg.lg23Mode;
      scale = cfg.lg23Scale;
      priority = 3;
    }
  ];

  byPriority = lib.sort (a: b: a.priority < b.priority) externals;

  # Logical width = pixels / scale; used to place the next output to its right.
  parseWidth = mode: lib.toInt (lib.head (lib.splitString "x" mode));
  logicalW = d: builtins.floor (parseWidth d.mode / d.scale);
  pos = x: "${toString x},0";

  # ---- kanshi output builders -------------------------------------------
  enableExternal = d: p: {
    inherit (d) criteria mode scale;
    status = "enable";
    position = p;
    transform = "normal";
    adaptiveSync = false;
  };

  disableExternal = d: {
    inherit (d) criteria;
    status = "disable";
  };

  laptopEnabled = p:
    {
      criteria = laptop;
      status = "enable";
      position = p;
      scale = 1.0;
      transform = "normal";
      adaptiveSync = false;
    }
    // lib.optionalAttrs (cfg.laptopMode != null) {mode = cfg.laptopMode;};

  laptopDisabled = {
    criteria = laptop;
    status = "disable";
  };

  # ---- connected-set enumeration ----------------------------------------
  # k-subsets of xs preserving order.
  combos = n: xs:
    if n == 0
    then [[]]
    else if xs == []
    then []
    else let
      h = lib.head xs;
      t = lib.tail xs;
    in
      (map (c: [h] ++ c) (combos (n - 1) t)) ++ (combos n t);

  pairs = combos 2 byPriority;
  singles = combos 1 byPriority;
  # Larger sets first so the most specific profile wins the hotplug default.
  allSets = pairs ++ singles ++ [[]];

  setKey = es:
    if es == []
    then "none"
    else lib.concatMapStringsSep "_" (d: d.id) es;

  profileName = es: state: "set_${setKey es}_${state}";

  # Cycle states for a connected set. The first state is the hotplug default.
  statesFor = es: let
    n = lib.length es;
  in
    if n == 2
    then let
      a = lib.elemAt es 0;
      b = lib.elemAt es 1;
      wa = logicalW a;
      wb = logicalW b;
    in [
      {
        state = "primary";
        outputs = [laptopDisabled (enableExternal a (pos 0)) (disableExternal b)];
      }
      {
        state = "dual";
        outputs = [laptopDisabled (enableExternal a (pos 0)) (enableExternal b (pos wa))];
      }
      {
        state = "dual_lap";
        outputs = [(laptopEnabled (pos (wa + wb))) (enableExternal a (pos 0)) (enableExternal b (pos wa))];
      }
      {
        state = "lap";
        outputs = [(laptopEnabled (pos 0)) (disableExternal a) (disableExternal b)];
      }
    ]
    else if n == 1
    then let
      a = lib.elemAt es 0;
      wa = logicalW a;
    in [
      {
        state = "solo";
        outputs = [laptopDisabled (enableExternal a (pos 0))];
      }
      {
        state = "solo_lap";
        outputs = [(laptopEnabled (pos wa)) (enableExternal a (pos 0))];
      }
      {
        state = "lap";
        outputs = [(laptopEnabled (pos 0)) (disableExternal a)];
      }
    ]
    else [
      {
        state = "lap";
        outputs = [(laptopEnabled (pos 0))];
      }
    ];

  notify = name: "notify-send kanshi '${name}'";

  mkProfile = es: s: {
    profile = {
      name = profileName es s.state;
      exec = [(notify (profileName es s.state))];
      inherit (s) outputs;
    };
  };

  allProfiles = lib.concatMap (es: map (mkProfile es) (statesFor es)) allSets;

  # setKey -> ordered profile names (cycle order), consumed by the switcher.
  lookup = lib.listToAttrs (map (es: {
      name = setKey es;
      value = map (s: profileName es s.state) (statesFor es);
    })
    allSets);

  # External identity table for runtime detection.
  detectTable = map (d: {inherit (d) id criteria priority;}) byPriority;

  switcher = pkgs.writeShellApplication {
    name = "kanshi-switch";
    runtimeInputs = [pkgs.wlr-randr pkgs.jq pkgs.kanshi pkgs.libnotify];
    text = ''
      # Usage: kanshi-switch [cycle|laptop|default]
      #   cycle   - step to the next layout for the currently connected outputs
      #   laptop  - jump straight to laptop-only (undocked)
      #   default - jump to the default layout (primary external only)
      lookup=${lib.escapeShellArg (builtins.toJSON lookup)}
      detect=${lib.escapeShellArg (builtins.toJSON detectTable)}
      state_file="''${XDG_RUNTIME_DIR:-/tmp}/kanshi-switch.state"
      mode="''${1:-cycle}"

      outputs="$(wlr-randr --json)"

      # Connected external ids, ordered by priority.
      connected="$(jq -cn --argjson outs "$outputs" --argjson det "$detect" '
        [ $det[] as $d
          | select(any($outs[];
              (((.make // "") + " " + (.model // "") + " " + (.serial // "")) == $d.criteria)))
          | $d ]
        | sort_by(.priority) | map(.id)')"

      key="$(jq -rn --argjson c "$connected" \
        'if ($c | length) == 0 then "none" else ($c | join("_")) end')"

      names="$(jq -cn --argjson l "$lookup" --arg k "$key" '$l[$k] // []')"
      count="$(jq -rn --argjson n "$names" '$n | length')"

      if [ "$count" -eq 0 ]; then
        notify-send kanshi "no profile for outputs: $key" || true
        exit 0
      fi

      if [ "$mode" = "laptop" ]; then
        idx=$((count - 1))
      elif [ "$mode" = "default" ]; then
        idx=0
      else
        idx=0
        if [ -f "$state_file" ]; then
          saved="$(cat "$state_file")"
          skey="''${saved%%:*}"
          sidx="''${saved##*:}"
          if [ "$skey" = "$key" ]; then
            idx=$(( (sidx + 1) % count ))
          fi
        fi
      fi

      profile="$(jq -rn --argjson n "$names" --argjson i "$idx" '$n[$i]')"
      printf '%s:%s\n' "$key" "$idx" > "$state_file"
      kanshictl switch "$profile"
    '';
  };

  cycleCmd = "${lib.getExe switcher} cycle";
  laptopCmd = "${lib.getExe switcher} laptop";
  resetCmd = "${lib.getExe switcher} default";
in
  with lib; {
    options.desktop.wayland.kanshi = {
      enable = mkEnableOption "kanshi";
      lgMode = mkOption {
        type = types.str;
        default = "3840x2160@60Hz";
        description = "LG 4K monitor mode";
      };
      lgScale = mkOption {
        type = types.float;
        default = 1.5;
        description = "LG 4K monitor scale factor";
      };
      asusMode = mkOption {
        type = types.str;
        default = "1920x1080@74.986Hz";
        description = "ASUS VA24E monitor mode";
      };
      asusScale = mkOption {
        type = types.float;
        default = 1.0;
        description = "ASUS VA24E monitor scale factor";
      };
      lg23Mode = mkOption {
        type = types.str;
        default = "1920x1080@60Hz";
        description = "LG 23MP55 monitor mode";
      };
      lg23Scale = mkOption {
        type = types.float;
        default = 1.0;
        description = "LG 23MP55 monitor scale factor";
      };
      laptopMode = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Laptop display mode when enabled (null = compositor preferred)";
      };
    };

    config = mkIf cfg.enable {
      home.packages = [pkgs.wdisplays switcher];

      services.kanshi = {
        enable = true;
        settings = allProfiles;
      };

      wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
        keybindings = {
          "Ctrl+Alt+space" = "exec ${cycleCmd}";
          "Ctrl+Alt+u" = "exec ${laptopCmd}";
          "Ctrl+Alt+r" = "exec ${resetCmd}";
        };
      };

      wayland.windowManager.hyprland.settings =
        lib.mkIf config.desktop.wayland.compositors.hyprland.enable
        {
          bind = [
            {
              _args = ["CTRL + ALT + Space" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON cycleCmd})")];
            }
            {
              _args = ["CTRL + ALT + U" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON laptopCmd})")];
            }
            {
              _args = ["CTRL + ALT + R" (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON resetCmd})")];
            }
          ];
        };
    };
  }
