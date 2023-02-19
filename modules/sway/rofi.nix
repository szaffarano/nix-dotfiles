{ config, lib, pkgs, ... }: {
  options.rofi.enable = lib.mkEnableOption "rofi";
  options.rofi.terminal = lib.mkOption {
    type = lib.types.str;
    default = "kitty";
  };
  options.rofi.theme = lib.mkOption {
    type = lib.types.str;
    default = "catppuccin-mocha";
  };
  options.rofi.icon-theme = lib.mkOption {
    type = lib.types.str;
    default = "Oranchelo";
  };

  config = lib.mkIf config.rofi.enable {
    home.packages = with pkgs; [
      rofi-bluetooth
      rofi-power-menu
      rofi-pulse-select
    ];

    wayland.windowManager.sway = { config = { menu = "rofi -show drun"; }; };

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      cycle = true;
      terminal = config.rofi.terminal;
      theme = config.rofi.theme;
      plugins = with pkgs; [
        rofi-bluetooth
        rofi-calc
        rofi-emoji
        rofi-power-menu
        rofi-pulse-select
      ];
      extraConfig = {
        modi = "run,drun,ssh,combi,keys,filebrowser";
        icon-theme = config.rofi.icon-theme;
        show-icons = true;
        drun-display-format = "{icon} {name}";
        location = 0;
        disable-history = false;
        hide-scrollbar = true;
        display-drun = "   Apps ";
        display-run = "   Run ";
        display-window = "   Window";
        display-Network = " 󰤨  Network";
        sidebar-mode = true;
      };
    };
  };
}
