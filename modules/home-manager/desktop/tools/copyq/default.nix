{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.desktop.tools.copyq;
in
with lib;
{

  options.desktop.tools.copyq.enable = mkEnableOption "copyq";

  config = mkIf cfg.enable {
    xdg.configFile."copyq/copyq.conf".source = ./config/copyq.conf;
    xdg.configFile."copyq/copyq-commands.ini".source = ./config/copyq-commands.ini;
    wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.hyprland.enable {
      floating.criteria = [
        { app_id = "copyq"; }
      ];
      keybindings = {
        "Ctrl+Alt+v" = "exec copyq toggle";
      };
    };
    wayland.windowManager.hyprland = lib.mkIf config.desktop.wayland.compositors.hyprland.enable {
      settings = {
        bind = [ "CTRL_ALT,v,exec,copyq toggle" ];
        windowrulev2 = [
          "float,class:^(com\.github\.hluk\.copyq)$"
        ];
      };
    };

    # TODO: create PR to parameterize `QT_QPA_PLATFORM`
    home.packages = with pkgs; [ copyq ];
    services.copyq.enable = false;
    systemd.user.services.copyq = {
      Unit = {
        Description = "CopyQ clipboard management daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.copyq}/bin/copyq";
        Restart = "on-failure";
        Environment = [ "QT_QPA_PLATFORM=wayland" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

  };
}
