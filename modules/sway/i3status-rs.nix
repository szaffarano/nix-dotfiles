{ config, lib, pkgs, ... }:
with lib;
let
  fontOptions = types.submodule {
    options = {
      names = mkOption { type = types.listOf types.str; };
      style = mkOption { type = types.str; };
      size = mkOption { type = types.float; };
    };
  };

in
{
  options.i3status-rs.enable = lib.mkEnableOption "i3status-rs";
  options.i3status-rs.fonts = lib.mkOption { type = fontOptions; };

  config = lib.mkIf config.i3status-rs.enable {

    wayland.windowManager.sway.config.bars = [{
      statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";
      command = "swaybar";
      fonts = config.i3status-rs.fonts;
      position = "bottom";
      extraConfig = "height 32";
      trayOutput = "*";
    }];

    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          icons = "awesome";
          theme = "semi-native";
          blocks = [
            {
              block = "music";
              player = "ncspot";
            }
            {
              block = "disk_space";
              unit = "GB";
              warning = 20.0;
              alert = 10.0;
            }
            {
              block = "memory";
              display_type = "memory";
              format_mem = "{mem_used_percents}";
              format_swap = "{swap_used_percents}";
            }
            {
              block = "cpu";
              interval = 1;
            }
            {
              block = "load";
              interval = 1;
              format = "{1m}";
            }
            {
              block = "battery";
              interval = 10;
              format = "{percentage} {time}";
            }
            {
              block = "keyboard_layout";
              driver = "sway";
              format = "{layout}";
              mappings = {
                "English (intl., with AltGr dead keys)" = "En";
                "English (Dvorak, intl., with dead keys)" = "En[Dvorak]";
              };
            }
            {
              block = "networkmanager";
              on_click = "kitty --title nmtui-wifi-edit nmtui";
              interface_name_exclude = [ "^virbr+" "^docker+" "^enp*" ];
              interface_name_include = [ ];
              ap_format = "{ssid^10}";
              device_format = "{icon} {ap}";
            }
            {
              block = "sound";
              step_width = 3;
              on_click = "pavucontrol";
            }
            {
              block = "bluetooth";
              mac = "C4:6E:7B:01:7B:4A";
              format = "{label}";
            }
            {
              block = "bluetooth";
              mac = "74:45:CE:4C:56:36";
              format = "{label}";
            }
            {
              block = "bluetooth";
              mac = "DC:2C:26:2C:EE:46";
              format = "{label}";
            }
            {
              block = "time";
              interval = 60;
              format = "%a %d/%m %R";
            }
          ];
        };
      };
    };
  };
}
