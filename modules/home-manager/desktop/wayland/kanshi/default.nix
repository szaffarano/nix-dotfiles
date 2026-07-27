{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.kanshi;
  kanshictl = lib.getExe' pkgs.kanshi "kanshictl";

  lg = "LG Electronics LG HDR 4K 301MAPNGQZ84";
  asus = "ASUSTek COMPUTER INC ASUS VA24E LBLMTF309577";
  laptop = "eDP-1";

  trySwitch = profiles:
    lib.concatStringsSep " || " (map (p: "${kanshictl} switch ${p}") profiles);

  switchDual = trySwitch ["docked-dual"];
  switchSingle = trySwitch ["docked-single" "docked-single-lg"];
  switchAsus = trySwitch ["asus-only" "asus-laptop"];
  switchUndocked = trySwitch ["undocked" "undocked-no-asus" "undocked-no-lg"];

  notify = name: "notify-send kanshi '${name} applied'";

  lgEnabled = {
    criteria = lg;
    status = "enable";
    mode = cfg.lgMode;
    position = "0,0";
    scale = cfg.lgScale;
    transform = "normal";
    adaptiveSync = false;
  };

  asusEnabled = pos: {
    criteria = asus;
    status = "enable";
    mode = "1920x1080@74.986Hz";
    position = pos;
    scale = 1.0;
    transform = "normal";
    adaptiveSync = false;
  };

  laptopEnabled =
    {
      criteria = laptop;
      status = "enable";
      position = "0,0";
      scale = 1.0;
      transform = "normal";
      adaptiveSync = false;
    }
    // lib.optionalAttrs (cfg.laptopMode != null) {mode = cfg.laptopMode;};
in
  with lib; {
    options.desktop.wayland.kanshi = {
      enable = mkEnableOption "kanshi";
      lgMode = mkOption {
        type = types.str;
        default = "3840x2160@60Hz";
        description = "LG monitor mode";
      };
      lgScale = mkOption {
        type = types.float;
        default = 1.5;
        description = "LG monitor scale factor";
      };
      laptopMode = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Laptop display mode when enabled (null = compositor preferred)";
      };
    };

    config = mkIf cfg.enable {
      home.packages = [pkgs.wdisplays];

      services.kanshi = {
        enable = true;
        settings = [
          # 3-output profiles — first match wins on tie, so docked-single is default
          {
            profile = {
              name = "docked-single";
              exec = [(notify "docked-single")];
              outputs = [
                {
                  criteria = laptop;
                  status = "disable";
                }
                lgEnabled
                {
                  criteria = asus;
                  status = "disable";
                }
              ];
            };
          }
          {
            profile = {
              name = "docked-dual";
              exec = [(notify "docked-dual")];
              outputs = [
                {
                  criteria = laptop;
                  status = "disable";
                }
                lgEnabled
                (asusEnabled "2560,0")
              ];
            };
          }
          {
            profile = {
              name = "undocked";
              exec = [(notify "undocked")];
              outputs = [
                laptopEnabled
                {
                  criteria = lg;
                  status = "disable";
                }
                {
                  criteria = asus;
                  status = "disable";
                }
              ];
            };
          }
          {
            profile = {
              name = "asus-only";
              exec = [(notify "asus-only")];
              outputs = [
                {
                  criteria = laptop;
                  status = "disable";
                }
                {
                  criteria = lg;
                  status = "disable";
                }
                (asusEnabled "0,0")
              ];
            };
          }
          # 2-output profiles — auto-detect when one external is absent
          {
            profile = {
              name = "docked-single-lg";
              exec = [(notify "docked-single-lg")];
              outputs = [
                {
                  criteria = laptop;
                  status = "disable";
                }
                lgEnabled
              ];
            };
          }
          {
            profile = {
              name = "asus-laptop";
              exec = [(notify "asus-laptop")];
              outputs = [
                {
                  criteria = laptop;
                  status = "disable";
                }
                (asusEnabled "0,0")
              ];
            };
          }
          # Undocked fallbacks for when only one external is present
          {
            profile = {
              name = "undocked-no-asus";
              exec = [(notify "undocked-no-asus")];
              outputs = [
                laptopEnabled
                {
                  criteria = lg;
                  status = "disable";
                }
              ];
            };
          }
          {
            profile = {
              name = "undocked-no-lg";
              exec = [(notify "undocked-no-lg")];
              outputs = [
                laptopEnabled
                {
                  criteria = asus;
                  status = "disable";
                }
              ];
            };
          }
        ];
      };

      wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
        keybindings = {
          "Ctrl+Alt+D" = "exec ${switchDual}";
          "Ctrl+Alt+S" = "exec ${switchSingle}";
          "Ctrl+Alt+A" = "exec ${switchAsus}";
          "Ctrl+Alt+U" = "exec ${switchUndocked}";
        };
      };

      wayland.windowManager.hyprland.settings =
        lib.mkIf config.desktop.wayland.compositors.hyprland.enable
        {
          bind = [
            "CTRL_ALT,D,exec,${switchDual}"
            "CTRL_ALT,S,exec,${switchSingle}"
            "CTRL_ALT,A,exec,${switchAsus}"
            "CTRL_ALT,U,exec,${switchUndocked}"
          ];
        };
    };
  }
