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
        cliphist.enable = lib.mkDefault true;
        copyq.enable = lib.mkDefault false;
        gammastep.enable = lib.mkDefault true;
        keepassxc.enable = lib.mkDefault true;
        screenshot.enable = lib.mkDefault true;
        udiskie.enable = lib.mkDefault true;
        zathura.enable = lib.mkDefault true;
      };
      home.packages = with pkgs; [
        virt-manager
        docker-credential-helpers
        bruno

        inputs.temporis.temporis-desktop

        # security
        # TODO: move to security.nix ?
        wireshark
        psmisc
      ];
    };
  }
