{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.desktop.wayland.compositors.hyprland;
in
with lib;
{

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pyprland ];

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

    xdg.configFile."hypr/pyprland.toml".source = (pkgs.formats.toml { }).generate "pyprland" {
      pyprland = {
        plugins = [ "scratchpads" ];
      };

      scratchpads =
        let
          terminal = "${pkgs.wezterm}/bin/wezterm";
        in
        {
          musicPlayer = {
            command = "${terminal} start --class=musicPlayer zsh --login -c '${pkgs.ncspot}/bin/ncspot'";
            class = "musicPlayer";
            size = "50% 50%";
            position = "25% 25%";
            unfocus = "hide";
            lazy = true;
          };

          slack = {
            command = "${pkgs.slack}/bin/slack";
            class = "Slack";
            size = "70% 70%";
            position = "15% 15%";
            lazy = true;
          };

          orgmode = {
            command = "${terminal} start --class=orgmode zsh --login -c '${pkgs.neovim}/bin/nvim +WikiIndex'";
            class = "orgmode";
            size = "70% 70%";
            position = "15% 15%";
            unfocus = "hide";
            lazy = true;
          };
        };
    };
  };
}
