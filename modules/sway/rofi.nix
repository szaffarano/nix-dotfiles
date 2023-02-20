{ config, lib, pkgs, ... }: {
  options.rofi.enable = lib.mkEnableOption "rofi";
  options.rofi.terminal = lib.mkOption {
    type = lib.types.str;
    default = "kitty";
  };
  options.rofi.catppuccinVariat = lib.mkOption {
    type = lib.types.str;
    default = "catppuccin-mocha";
  };

  config = let
    catppuccin = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "rofi";
      rev = "5350da4";
      sha256 = "sha256-DNorfyl3C4RBclF2KDgwvQQwixpTwSRu7fIvihPN8JY=";
    };

  in lib.mkIf config.rofi.enable {
    xdg.dataFile."rofi/themes" = {
      source = "${catppuccin}/basic/.local/share/rofi/themes/";
    };

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
      theme = config.rofi.catppuccinVariat;
      plugins = with pkgs; [
        rofi-bluetooth
        rofi-calc
        rofi-emoji
        rofi-power-menu
        rofi-pulse-select
      ];
      extraConfig = {
        modi = "run,drun,ssh,combi,keys,filebrowser";
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
