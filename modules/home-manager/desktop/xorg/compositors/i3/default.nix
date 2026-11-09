{
  theme,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.xorg.compositors.i3;
  i3statusRs = "${pkgs.i3status-rust}/bin/i3status-rs";
in
  with lib; {
    options.desktop.xorg.compositors.i3.enable = mkEnableOption "i3";

    imports = [
      ./colors.nix
      ./fish.nix
      ./floating-criteria.nix
      ./keybindings.nix
      ./window-commands.nix
    ];

    config = mkIf cfg.enable {
      desktop.xorg = {
        i3lock.enable = true;
        xautolock.enable = true;
      };

      xsession = {
        enable = true;
        windowManager.i3 = {
          enable = true;

          config = {
            modifier = "Mod4";
            defaultWorkspace = "workspace number 1";
            workspaceAutoBackAndForth = true;
            terminal = config.home.sessionVariables.TERMINAL;

            fonts = with config.fontProfiles.monospace; {
              names = [name];
              size = sizeAsInt * 0.9;
            };

            window.titlebar = false;

            bars = lib.optionals config.desktop.xorg.i3status-rust.enable [
              {
                id = "main";
                position = "bottom";
                statusCommand = "${i3statusRs} ~/.config/i3status-rust/config-default.toml";
                fonts = with config.fontProfiles.monospace; {
                  names = [name];
                  size = sizeAsInt * 0.9;
                };
                trayOutput = "primary";
              }
            ];

            startup = let
              configure-gtk = lib.getExe pkgs.configure-gtk;
              tmux = lib.getExe pkgs.tmux;
              fish = lib.getExe pkgs.fish;
            in [
              {
                command = "setxkbmap -layout 'us,us' -variant 'altgr-intl,dvorak' -option 'grp:rctrl_toggle'";
                always = true;
                notification = false;
              }
              {
                command = "xset r rate 250 25";
                always = true;
                notification = false;
              }
              {
                command = ''${config.home.sessionVariables.TERMINAL} --class dev-terminal -e ${fish} -c "${tmux} attach -s random || ${tmux} new -s random"'';
                notification = false;
              }
              {
                command = ''
                  ${configure-gtk} \
                      '${theme.gtk.theme}' \
                      '${theme.gtk.cursor-theme}' \
                      '${theme.gtk.icon-theme}' \
                      '${config.fontProfiles.regular.name}' \
                      '${config.fontProfiles.monospace.name}'
                '';
                always = true;
                notification = false;
              }
            ];

            assigns = {
              "1" = [{class = "firefox";}];
              "2" = [{class = "jetbrains-idea";}];
              "3" = [{instance = "dev-terminal";}];
            };

            modes = {
              resize = {
                "h" = "resize shrink width 10 px or 10 ppt";
                "l" = "resize grow width 10 px or 10 ppt";
                "j" = "resize shrink height 10 px or 10 ppt";
                "k" = "resize grow height 10 px or 10 ppt";
                Return = "mode default";
                Escape = "mode default";
              };
            };
          };
        };
      };
    };
  }
