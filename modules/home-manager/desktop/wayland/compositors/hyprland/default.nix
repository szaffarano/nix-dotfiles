{
  config,
  lib,
  pkgs,
  theme,
  ...
}:
let
  cfg = config.desktop.wayland.compositors.hyprland;
  hyprland = pkgs.inputs.hyprland.hyprland;
  terminal = "${pkgs.wezterm}/bin/wezterm";
  xdph = pkgs.inputs.hyprland.xdg-desktop-portal-hyprland.override { inherit hyprland; };
  hyprlockCmd = "${pkgs.hyprlock}/bin/hyprlock";
in
with lib;
{
  options.desktop.wayland.compositors.hyprland.enable = mkEnableOption "hyprland";

  imports = [ ./keybindings.nix ];

  config = mkIf cfg.enable {

    desktop.wayland.swaync.enable = true;

    xdg.portal = {
      extraPortals = [ xdph ];
      configPackages = [ hyprland ];
    };

    home.packages = with pkgs; [
      hypridle
      hyprlock
      hyprpicker
      inputs.hyprland-contrib.grimblast
      pyprland
    ];

    home.sessionVariables = {
      XCURSOR_SIZE = 16;
      XCURSOR_THEME = theme.gtk.cursor-theme;
    };

    systemd.user.services.pyprland = {
      Unit = {
        Description = "Pyprland daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.pyprland}/bin/pypr";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    xdg.configFile."hypr/hyprlock.conf".text = ''
      background {
        monitor =
        path = screenshot
        blur_passes = 2
        blur_size = 4
        noise = 0.05
        contrast = 0.8
        brightness = 0.4
        vibrancy = 0.2
        vibrancy_darkness = 0.1
      }

      input-field {
        monitor =
        size = 250, 40
        outline_thickness = 2
        dots_size = 0.20
        dots_spacing = 0.1
        dots_center = false
        outer_color = rgb(0, 0, 0)
        inner_color = rgb(200, 200, 200)
        font_color = rgb(60, 90, 30)
        fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
        fade_on_empty = true
        placeholder_text = <i>Input Password...</i>
        hide_input = false
        position = 0, -20
        halign = center
        valign = center
      }

      label {
        monitor =
        text = cmd[update:1000] echo "<b>$(date '+%Y-%m-%d %H:%M:%S %Z')</b>"
        color = rgba(100, 100, 100, 1.0)
        font_size = 25
        font_family = Noto Sans
        position = 0, 80
        halign = center
        valign = center
      }
    '';
    xdg.configFile."hypr/hypridle.conf".text = ''
      general {
        lock_cmd = pidof hyprlock || ${hyprlockCmd}
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
      }

      listener {
        timeout =300 
        on-timeout = loginctl lock-session
      }

      listener {
        timeout = 380
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
      }

      listener {
        timeout =1800 
        on-timeout = systemctl suspend
      }
    '';

    xdg.configFile."hypr/pyprland.toml".text = ''
      [pyprland]
        plugins = ["scratchpads"]

      [scratchpads.musicPlayer]
        command = "${terminal} start --class=musicPlayer zsh --login -c '${pkgs.ncspot}/bin/ncspot'"
        class = "musicPlayer"
        size = "50% 50%"
        position = "25% 25%"
        unfocus = "hide"
        lazy = true

      [scratchpads.slack]
        command = "${pkgs.slack}/bin/slack"
        class = "Slack"
        size = "70% 70%"
        position = "15% 15%"
        lazy = true

      [scratchpads.orgmode]
        command = "${terminal} start --class=orgmode zsh --login -c '${pkgs.neovim}/bin/nvim +WikiIndex'"
        class = "orgmode"
        size = "70% 70%"
        position = "15% 15%"
        unfocus = "hide"
        lazy = true
    '';

    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprland;

      settings = {
        "$terminal" = terminal;
        "$mod" = "SUPER";

        # https://wiki.hyprland.org/Configuring/Variables/#general
        general = {
          layout = "dwindle";
          gaps_out = 2;
          border_size = 2;
          cursor_inactive_timeout = 10;
          resize_corner = 1; # 1-4 going clockwise from top left
          # col.active_border = "rgba(eeeeeeee) rgba(777777ee) 45deg";
          # col.inactive_border = "rgba(595959aa)";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        decoration = {
          rounding = 2;
        };

        animations = {
          enabled = false;
        };

        # https://wiki.hyprland.org/Configuring/Variables/#input
        input = {
          kb_layout = "us,us";
          kb_variant = "altgr-intl,dvorak";
          kb_options = "grp:rctrl_ralt_toggle";
          repeat_rate = 25;
          repeat_delay = 250;
          follow_mouse = 0;

          touchpad = {
            disable_while_typing = true;
            clickfinger_behavior = true;
          };
        };

        # https://wiki.hyprland.org/Configuring/Variables/#misc
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        binds = {
          workspace_back_and_forth = true;
        };

        "exec-once" =
          let
            configure-gtk = "${pkgs.configure-gtk}/bin/configure-gtk";
          in
          [
            ''$terminal start --class=dev-terminal zsh --login -c "tmux attach -t random || tmux new -s random"''
            ''${configure-gtk} '${theme.gtk.theme}' '${theme.gtk.cursor-theme}' '${theme.gtk.icon-theme}' '${config.fontProfiles.regular.name}' '${config.fontProfiles.monospace.name}' ''
          ]
          ++ (lib.optionals config.desktop.tools.keepassxc.enable ([ "${pkgs.keepassxc}/bin/keepassxc" ]));

        windowrulev2 = [
          "workspace 1,class:^(firefox)$"
          "workspace 2,class:^(jetbrains-idea)$"
          "workspace 3,class:^(dev-terminal)$"

          "float,class:^(com.github.hluk.copyq)$"
          "float,class:^(org.keepassxc.KeePassXC)$"
          "float,class:^(nm-connection-editor)$"
          "float,class:^(blueberry.py)$"
          "float,class:^(transmission-qt)$"

          "float,class:^(pavucontrol)$"
          "size 60% 60%,class:^(pavucontrol)$"
          "center,class:^(pavucontrol)$"
        ];
      };
    };
  };
}
