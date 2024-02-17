{ config, lib, pkgs, ... }:
let cfg = config.desktop.tools.copyq;
in with lib; {

  options.desktop.tools.copyq.enable = mkEnableOption "copyq";

  config = mkIf cfg.enable {
    xdg.configFile."copyq/copyq.conf".source = ./config/copyq.conf;
    xdg.configFile."copyq/copyq-commands.ini".source =
      ./config/copyq-commands.ini;

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

      Install = { WantedBy = [ "graphical-session.target" ]; };
    };

  };
}
