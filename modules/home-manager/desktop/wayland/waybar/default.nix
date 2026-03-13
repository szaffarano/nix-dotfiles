{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.waybar;
  pavucontrol = lib.getExe pkgs.pavucontrol;
  blueman = "${pkgs.blueman}/bin/blueman-manager";
  swayNcClient = "${pkgs.swaynotificationcenter}/bin/swaync-client";
in
  with lib; {
    options.desktop.wayland.waybar.enable = mkEnableOption "waybar";

    config = mkIf cfg.enable {
      programs.waybar = {
        enable = true;
        systemd.enable = true;

        settings = {
          primary = {
            layer = "top";
            position = "bottom";

            height = 30;

            modules-left =
              (lib.optionals config.wayland.windowManager.sway.enable [
                "sway/workspaces"
                "custom/sep"
                "sway/scratchpad"
                "sway/mode"
              ])
              ++ (lib.optionals config.wayland.windowManager.hyprland.enable [
                "hyprland/workspaces"
                "hyprland/submap"
              ]);

            modules-center = [];

            modules-right = [
              "pulseaudio"
              "custom/sep"
              "bluetooth"
              "custom/sep"
              "cpu"
              "custom/sep"
              "disk"
              "custom/sep"
              "memory"
              "custom/sep"
              "battery"
              "custom/sep"
              (lib.optionalString config.wayland.windowManager.hyprland.enable "hyprland/language")
              (lib.optionalString config.wayland.windowManager.sway.enable "sway/language")
              "custom/sep"
              "network"
              "custom/sep"
              "idle_inhibitor"
              "custom/sep"
              "clock"
              "custom/sep"
              "tray"
              "custom/sep"
              "custom/notifications"
            ];

            "sway/workspaces" = {
              disable-scroll = true;
              all-outputs = true;
              format = "{name}: {icon}";
              sort-by = "number";
              format-icons = {
                "1" = "";
                "2" = "";
                "3" = "";
                "4" = "";
                "5" = "";
                "6" = "";
                "7" = "";
                "urgent" = "";
                "default" = "";
              };
              persistent-workspaces = {
                "1" = [];
                "2" = [];
                "3" = [];
              };
            };
            "hyprland/workspaces" = {
              format = "{name}: {icon}";
              sort-by = "number";
              format-icons = {
                "1" = "";
                "2" = "";
                "3" = "";
                "4" = "";
                "5" = "";
                "6" = "";
                "7" = "";
                "urgent" = "";
                "default" = "";
              };
              persistent-workspaces = {
                "1" = [];
                "2" = [];
                "3" = [];
              };
            };

            "sway/language" = {
              "format" = "{} {variant}";
            };

            "hyprland/language" = {
              format = "US {variant}";
            };

            pulseaudio = {
              format = " {icon} {volume}%";
              format-muted = " {volume}%";
              format-bluetooth = " {icon} {volume}%";
              format-icons = {
                headphones = " ";
                default = [
                  ""
                  ""
                  " "
                ];
              };
              on-click = pavucontrol;
            };

            "sway/scratchpad" = {
              format = "{icon} {count}";
              show-empty = true;
              format-icons = [
                " "
                " "
              ];
              tooltip = true;
              tooltip-format = "{app}: {title}";
            };

            "sway/mode" = {
              format = " {}";
            };

            bluetooth = {
              on-click = "${blueman}";
              format = " {status}";
              format-device-preference = ["Keychron K2"];
              # format-connected = " {device_alias}";
              format-connected = "";
              format-connected-battery = " {device_alias} {device_battery_percentage}%";
              tooltip-format = ''
                {controller_alias}	{controller_address}
                {num_connections} connected'';
              tooltip-format-connected = ''
                {controller_alias}	{controller_address}
                {num_connections} connected
                {device_enumerate}'';
              tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
              tooltip-format-enumerate-connected-battery = "{device_alias}	{device_address}	{device_battery_percentage}%";
            };

            network = {
              interval = "1";
              format-wifi = "{icon}";
              format-ethernet = "🖧";
              format-disconnected = " Disconnected";
              format-icons = [" "];
              max-length = "5";
              tooltip-format = ''
                SSID: {essid}
                Interface: {ifname}
                Signal: {signalStrength}%
                IP: {ipaddr}'';
            };

            cpu = {
              format = "󰾆 {usage}%";
              on-click = "kitty --title floating-terminal htop";
            };

            memory = {
              "interval" = 1;
              "format" = " {used:0.1f}/{total:0.1f}G";
            };

            battery = {
              interval = "60";
              format = "{icon} {capacity}%";
              states = {
                warning = "95";
                critical = "50";
              };
              format-icons = [
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
            };

            idle_inhibitor = {
              format = "{icon}";
              format-icons = {
                activated = "   ";
                deactivated = "   ";
              };
            };

            clock = let
              zenity = "${pkgs.zenity}/bin/zenity";
            in {
              format = "  {:%a %d %b %R %Z}";
              interval = 10;
              on-click = "${zenity} --calendar";
            };

            tray = {
              icon-size = 13;
              spacing = 6;
            };

            "custom/sep" = {
              "format" = "";
            };

            disk = {
              format = " {free}";
              interval = "30";
            };

            "custom/notifications" = {
              tooltip = false;
              format = "{icon}";
              format-icons = {
                notification = "<span foreground='red'><sup></sup></span>";
                none = "";
                dnd-notification = "<span foreground='red'><sup></sup></span>";
                dnd-none = "";
              };
              return-type = "json";
              exec-if = "test -f ${swayNcClient}";
              exec = "${swayNcClient} -swb";
              on-click = "${swayNcClient} -t -sw";
              on-click-right = "${swayNcClient} -d -sw";
              escape = true;
            };
          };
        };

        style = with config.colorScheme.palette; let
          font = config.fontProfiles.monospace;
        in
          ''
            @define-color bg #${base00};
            @define-color fg #${base05};
            @define-color fg2 #${base03};
            @define-color muted #${base04};
            @define-color neutral #${base06};
            @define-color critical #${base08};
            @define-color warning #${base09};
            @define-color ok #${base0B};

            * {
                font-family: ${font.name}, ${font.family};
                font-size: ${font.size};
            }
          ''
          + builtins.readFile ./style.css;
      };
    };
  }
