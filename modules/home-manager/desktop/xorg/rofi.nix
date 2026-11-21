{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.xorg.rofi;
in
  with lib; {
    imports = [../rofi/default.nix];
    options.desktop.xorg.rofi.enable = mkEnableOption "rofi";

    config = mkIf cfg.enable {
      desktop.rofi.enable = true;

      home.packages = [
        pkgs.rofi-power-menu
        pkgs.inputs.rofi-tools.rofi-clipcat
      ];
      services.clipcat = {
        enable = true;
        daemonSettings = {
          daemonize = true;
          max_history = 5000;

          log = {
            emit_journald = true;
            emit_stdout = false;
            emit_stderr = false;
            level = "INFO";
          };

          watcher = {
            enable_clipboard = true;
            enable_primary = false;
            sensitive_mime_types = ["x-kde-passwordManagerHint"];
            capture_image = true;
            filter_image_max_size = 5242880;
          };

          desktop_notification = {
            enable = true;
            timeout_ms = 2000;
            long_plaintext_length = 2000;
          };
        };
      };

      programs.rofi = {
        enable = true;
        settings. font = "${config.fontProfiles.regular.name} 15";
      };

      xsession.windowManager.i3.config = mkIf config.desktop.xorg.compositors.i3.enable {
        keybindings = let
          rofi = lib.getExe pkgs.rofi;
          powerMenu = "${rofi} -show p -modi 'p:${lib.getExe pkgs.rofi-power-menu} --choices=suspend/logout/lockscreen/reboot/shutdown/hibernate' -theme-str 'window {width: 8em;} listview {lines: 5; scrollbar: false;}'";
          clipboard = lib.getExe pkgs.inputs.rofi-tools.rofi-clipcat;
        in {
          "Mod4+d" = "exec ${rofi} -show run";
          "Mod4+x" = "exec ${rofi} -show drun";
          "Mod4+BackSpace" = ''exec "${powerMenu}"'';
          "Ctrl+Mod1+v" = "exec ${clipboard}";
        };
      };
    };
  }
