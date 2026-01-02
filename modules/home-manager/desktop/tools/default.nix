{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.tools;
in
  with lib; {
    imports = [
      ./cliphist
      ./copyq
      ./gammastep
      ./keepassxc
      ./screenshot
      ./udiskie
      ./zathura
    ];

    options.desktop.tools.enable = mkEnableOption "desktop tools";

    config = mkIf cfg.enable {
      desktop.tools = {
        cliphist.enable = true;
        copyq.enable = false;
        gammastep.enable = true;
        keepassxc.enable = true;
        screenshot.enable = true;
        udiskie.enable = true;
        zathura.enable = true;
      };
      home.packages = with pkgs; [
        virt-manager
        docker-credential-helpers
        # FIXME: broken package
        # bruno

        inputs.temporis.temporis-desktop

        # security
        # TODO: move to security.nix ?
        wireshark
        psmisc
      ];
    };
  }
