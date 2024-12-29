{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.rofi;
in
  with lib; {
    options.desktop.wayland.rofi.enable = mkEnableOption "rofi";

    config = let
      copy = "${pkgs.wl-clipboard}/bin/wl-copy";
      rofi = lib.getExe config.programs.rofi.finalPackage;
      cmd = "${rofi} -show calc -modi calc -no-show-match -no-sort -calc-command '${copy} {result}'";
      inherit (inputs.nix-colors.lib.conversions) hexToRGBString;
    in
      mkIf cfg.enable {
        xdg.dataFile."rofi/themes/${config.colorScheme.slug}.rasi".text = with config.colorScheme.palette; ''
          * {
              red:                         rgba ( ${hexToRGBString ", " base08}, 100 % );
              blue:                        rgba ( ${hexToRGBString ", " base0D}, 100 % );
              lightfg:                     rgba ( ${hexToRGBString ", " base06}, 100 % );
              lightbg:                     rgba ( ${hexToRGBString ", " base01}, 100 % );
              foreground:                  rgba ( ${hexToRGBString ", " base05}, 100 % );
              background:                  rgba ( ${hexToRGBString ", " base00}, 100 % );
              background-color:            rgba ( ${hexToRGBString ", " base00}, 0 % );
              separatorcolor:              @foreground;
              border-color:                @foreground;
              selected-normal-foreground:  @lightbg;
              selected-normal-background:  @lightfg;
              selected-active-foreground:  @background;
              selected-active-background:  @blue;
              selected-urgent-foreground:  @background;
              selected-urgent-background:  @red;
              normal-foreground:           @foreground;
              normal-background:           @background;
              active-foreground:           @blue;
              active-background:           @background;
              urgent-foreground:           @red;
              urgent-background:           @background;
              alternate-normal-foreground: @foreground;
              alternate-normal-background: @lightbg;
              alternate-active-foreground: @blue;
              alternate-active-background: @lightbg;
              alternate-urgent-foreground: @red;
              alternate-urgent-background: @lightbg;
          }
          window {
              background-color: @background;
              border:           1;
              padding:          5;
          }
          mainbox {
              border:           0;
              padding:          0;
          }
          message {
              border:           1px dash 0px 0px ;
              border-color:     @separatorcolor;
              padding:          1px ;
          }
          textbox {
              text-color:       @foreground;
          }
          listview {
              fixed-height:     0;
              border:           2px dash 0px 0px ;
              border-color:     @separatorcolor;
              spacing:          2px ;
              scrollbar:        true;
              padding:          2px 0px 0px ;
          }
          element-text, element-icon {
              background-color: inherit;
              text-color:       inherit;
          }
          element {
              border:           0;
              padding:          1px ;
          }
          element normal.normal {
              background-color: @normal-background;
              text-color:       @normal-foreground;
          }
          element normal.urgent {
              background-color: @urgent-background;
              text-color:       @urgent-foreground;
          }
          element normal.active {
              background-color: @active-background;
              text-color:       @active-foreground;
          }
          element selected.normal {
              background-color: @selected-normal-background;
              text-color:       @selected-normal-foreground;
          }
          element selected.urgent {
              background-color: @selected-urgent-background;
              text-color:       @selected-urgent-foreground;
          }
          element selected.active {
              background-color: @selected-active-background;
              text-color:       @selected-active-foreground;
          }
          element alternate.normal {
              background-color: @alternate-normal-background;
              text-color:       @alternate-normal-foreground;
          }
          element alternate.urgent {
              background-color: @alternate-urgent-background;
              text-color:       @alternate-urgent-foreground;
          }
          element alternate.active {
              background-color: @alternate-active-background;
              text-color:       @alternate-active-foreground;
          }
          scrollbar {
              width:            4px ;
              border:           0;
              handle-color:     @normal-foreground;
              handle-width:     8px ;
              padding:          0;
          }
          sidebar {
              border:           2px dash 0px 0px ;
              border-color:     @separatorcolor;
          }
          button {
              spacing:          0;
              text-color:       @normal-foreground;
          }
          button selected {
              background-color: @selected-normal-background;
              text-color:       @selected-normal-foreground;
          }
          inputbar {
              spacing:          0px;
              text-color:       @normal-foreground;
              padding:          1px ;
              children:         [ prompt,textbox-prompt-colon,entry,case-indicator ];
          }
          case-indicator {
              spacing:          0;
              text-color:       @normal-foreground;
          }
          entry {
              spacing:          0;
              text-color:       @normal-foreground;
          }
          prompt {
              spacing:          0;
              text-color:       @normal-foreground;
          }
          textbox-prompt-colon {
              expand:           false;
              str:              ":";
              margin:           0px 0.3000em 0.0000em 0.0000em ;
              text-color:       inherit;
          }
        '';

        home.packages = [pkgs.rofi-power-menu];

        wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
          keybindings = {
            "${config.wayland.windowManager.sway.config.modifier}+Shift+S" = cmd;
          };
        };

        wayland.windowManager.hyprland.settings =
          lib.mkIf config.desktop.wayland.compositors.hyprland.enable
          {
            bind = ["$mod_SHIFT,S,exec,${cmd}"];
          };

        programs.rofi = let
          rofi = pkgs.rofi-wayland;
        in {
          enable = true;
          package = rofi;
          plugins = [(pkgs.rofi-calc.override {rofi-unwrapped = rofi;})];
          theme = config.colorScheme.slug;
        };
      };
  }
