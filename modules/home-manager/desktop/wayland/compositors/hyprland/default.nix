{
  config,
  lib,
  pkgs,
  inputs,
  ...
}@params:
let
  cfg = config.desktop.wayland.compositors.hyprland;
  terminal = "${pkgs.wezterm}/bin/wezterm";
in
with lib;
{
  options.desktop.wayland.compositors.hyprland.enable = mkEnableOption "hyprland";

  imports = [ ./keybindings.nix ];

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      inputs.hyprland-contrib.packages.${pkgs.hostPlatform.system}.grimblast
      hyprpicker
      pyprland
    ];

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
        size = "70% 60%"
        position = "15% 20%"
        unfocus = "hide"
        lazy = true
    '';

    wayland.windowManager.hyprland = {
      enable = true;

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
          kb_layout = "us";
          kb_variant = "altgr-intl";
          repeat_rate = 20;
          repeat_delay = 200;
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

        "exec-once" = [
          ''$terminal start --class=dev-terminal zsh --login -c "tmux attach -t random || tmux new -s random"''
        ] ++ (lib.optionals config.desktop.tools.keepassxc.enable ([ "${pkgs.keepassxc}/bin/keepassxc" ]));

        windowrulev2 = [
          "workspace 1,class:^(firefox)$"
          "workspace 3,class:^(dev-terminal)$"

          "float,class:^(com.github.hluk.copyq)$"
          "float,class:^(org.keepassxc.KeePassXC)$"
          "float,class:^(nm-connection-editor)$"
          "float,class:^(blueberry.py)$"

          "float,class:^(pavucontrol)$"
          "size 60% 60%,class:^(pavucontrol)$"
          "center,class:^(pavucontrol)$"
        ];
      };
    };
  };
}
