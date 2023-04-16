{ config, lib, pkgs, theme, ... }: {
  options.waybar.enable = lib.mkEnableOption "waybar";

  config = lib.mkIf config.waybar.enable {
    programs.waybar = {
      settings = [{
        "layer" = "top";
        "position" = "bottom";
        "height" = 30;
        "modules-left" = [ "sway/workspaces" "custom/sep" "sway/scratchpad" ];
        "modules-center" = [ ];
        "modules-right" = [
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
          "sway/language"
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
          format-icons = {
            "1" = "󰖟";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "urgent" = "";
            "focused" = "";
            "default" = "";
          };
          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
          };
        };
        "sway/language" = { "format" = "{} {variant}"; };
        pulseaudio = {
          format = " {icon} {volume}%";
          format-muted = " {volume}%";
          format-bluetooth = " {icon} {volume}%";
          format-icons = {
            headphones = " ";
            default = [ "" "" " " ];
          };
          on-click = "pavucontrol";
        };
        "sway/scratchpad" = {
          format = "{icon}";
          show-empty = false;
          format-icons = [ " " " " ];
          tooltip = true;
          tooltip-format = "{app}: {title}";
        };
        bluetooth = {
          on-click = "blueberry";
          format = " {status}";
          format-device-preference = [ "Keychron K2" ];
          format-connected = " {device_alias}";
          format-connected-battery =
            " {device_alias} {device_battery_percentage}%";
          tooltip-format = ''
            {controller_alias}	{controller_address}
            {num_connections} connected'';
          tooltip-format-connected = ''
            {controller_alias}	{controller_address}
            {num_connections} connected
            {device_enumerate}'';
          tooltip-format-enumerate-connected =
            "{device_alias}	{device_address}";
          tooltip-format-enumerate-connected-battery =
            "{device_alias}	{device_address}	{device_battery_percentage}%";
        };
        network = {
          interval = "1";
          format-wifi = "{icon}";
          format-ethernet = " {ifname}";
          format-disconnected = " Disconnected";
          format-icons = [ " " ];
          max-length = "5";
          tooltip-format = ''
            SSID: {essid}
            Interface: {ifname}
            Signal: {signalStrength}%
            IP: {ipaddr}'';
        };
        cpu = {
          format = " {usage}%";
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
          format-icons = [ "" "" "" "" "" "" "" "" "" "" ];
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "   ";
            deactivated = "   ";
          };
        };
        clock = {
          format = "  {:%a %d %b %R %Z}";
          interval = 10;
          tooltip = true;
          tooltip-format = ''
            <tt>{timezoned_time_list}
            {:%B %Y}
            {calendar}</tt>'';
          on-click = "zenity --calendar";
          today-format = "<span color='red'><b>{}</b></span>";
          timezones = [
            "Europe/Stockholm"
            "Europe/Helsinki"
            "Europe/London"
            "US/Michigan"
          ];
        };
        tray = {
          icon-size = 16;
          spacing = 10;
        };
        "custom/sep" = { "format" = ""; };
        disk = {
          format = " {free}";
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
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

      }];

      style = builtins.replaceStrings
        ((builtins.attrNames theme.waybar.colors) ++ (builtins.attrNames theme.waybar.fonts))
        ((builtins.attrValues theme.waybar.colors) ++ (builtins.attrValues theme.waybar.fonts))
        (builtins.readFile ./style.css);
    };
    wayland.windowManager.sway = {
      config.bars = [ ];
      extraConfigEarly = ''
        exec waybar
      '';
    };

    programs.waybar = { enable = true; };
  };
}
