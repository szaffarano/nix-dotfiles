{ config
, lib
, pkgs
, theme
, ...
}:
let
  cfg = config.desktop.wayland.compositors.hyprland;
  hyprland = pkgs.inputs.hyprland.hyprland;
  terminal = "${pkgs.wezterm}/bin/wezterm";
  xdph = pkgs.inputs.hyprland.xdg-desktop-portal-hyprland.override { inherit hyprland; };
in
with lib;
{
  options.desktop.wayland.compositors.hyprland.enable = mkEnableOption "hyprland";

  imports = [
    ./hyprlock.nix
    ./keybindings.nix
    ./hypridle.nix
  ];

  config = mkIf cfg.enable {

    desktop.wayland.swaync.enable = true;

    # TODO review
    xdg.portal = {
      extraPortals = [ xdph ];
      configPackages = [ hyprland ];
    };

    home.packages = with pkgs; [ hyprpicker ];

    home.sessionVariables = {
      XCURSOR_SIZE = 16;
      XCURSOR_THEME = theme.gtk.cursor-theme;
    };

    programs.zsh.loginExtra = ''
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec ${hyprland}/bin/Hyprland \
          > ~/.cache/hyprland.log 2>~/.cache/hyprland.err.log
      fi
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
          gaps_in = 2;
          border_size = 2;
          cursor_inactive_timeout = 10;
          resize_on_border = true;
          "col.active_border" = "rgba(eeeeeeee) rgba(777777ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
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
          disable_hyprland_logo = false;
          disable_splash_rendering = false;
        };

        binds = {
          workspace_back_and_forth = true;
        };

        exec-once =
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

          "float,class:^(orgmode)$"
          "size 70% 70%,class:^(orgmode)$"
          "center,class:^(orgmode)$"
          "opacity 0.9 0.4, class:^(orgmode)$"
          "stayfocused, class:^(orgmode)$"

          "float,class:^(musicPlayer)$"
          "size 50% 50%,class:^(musicPlayer)$"
          "center,class:^(musicPlayer)$"
          "opacity 0.9 0.4, class:^(musicPlayer)$"

          "float,class:^(Slack)$"
          "size 70% 70%,class:^(Slack)$"
          "center,class:^(Slack)$"
          "opacity 0.9 0.4, class:^(Slack)$"
          "stayfocused, class:^(Slack)$"
        ];
      };
    };
  };
}
