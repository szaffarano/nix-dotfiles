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
      inherit (inputs.nix-colors.lib.conversions) hexToRGBString;

      copy = "${pkgs.wl-clipboard}/bin/wl-copy";
      rofi = lib.getExe config.programs.rofi.finalPackage;
      rofiCalc = "${rofi} -show calc -modi calc -no-show-match -no-sort -calc-command '${copy} {result}'";
      rofiPowerMenu = builtins.concatStringsSep " " (lib.splitString "\n" ''
        ${lib.getExe config.programs.rofi.package}
          -show p
          -modi 'p:rofi-power-menu --choices=suspend/logout/lockscreen/reboot/shutdown'
          -theme-str 'window {width: 8em;} listview {lines: 5;scrollbar: false;}'
      '');
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
              location: center;
              anchor:   center;
              transparency: "real";
              padding: 10px;
              border:  1px;
              border-radius: 10px;
              background-color: @background;
              spacing: 0;
              children:  [mainbox];
              orientation: horizontal;
          }
          mainbox {
              spacing: 0;
              children: [ inputbar, message, listview ];
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

        home.packages = [
          pkgs.rofi-power-menu
          pkgs.inputs.rofi-tools.rofi-cliphist
        ];

        wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
          keybindings = let
            inherit (config.wayland.windowManager.sway.config) modifier;
          in {
            "${modifier}+Shift+S" = "exec ${rofiCalc}";

            "${modifier}+d" = "exec ${rofi} -show run";
            "${modifier}+x" = "exec ${rofi} -show drun";
            "${modifier}+BackSpace" = "exec ${rofiPowerMenu}";
          };
        };

        wayland.windowManager.hyprland.settings =
          lib.mkIf config.desktop.wayland.compositors.hyprland.enable
          {
            bind = [
              "$mod_SHIFT,S,exec,${rofiCalc}"
              "$mod,x,exec,${rofi} -show drun"
              "$mod,d,exec,${rofi} -show run"
              "$mod,backspace,exec,${rofiPowerMenu}"
            ];
          };

        programs.rofi = {
          enable = true;
          font = "${config.fontProfiles.regular.name} 11";
          package = pkgs.rofi-wayland;
          plugins = [(pkgs.rofi-calc.override {rofi-unwrapped = pkgs.rofi-wayland;})];
          theme = config.colorScheme.slug;
          extraConfig = {
            show-icons = true;
          };
        };
      };
  }
