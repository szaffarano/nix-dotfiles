{ config, lib, pkgs, ... }:
let cfg = config.desktop.tools;
in with lib; {

  options.desktop.tools.enable = mkEnableOption "desktop tools";

  imports = [ ./copyq ./gammastep ./keepassxc ./screenshot ./zathura ];
  config = mkIf cfg.enable {
    desktop.tools = {
      copyq.enable = true;
      gammastep.enable = true;
      keepassxc.enable = true;
      screenshot.enable = true;
      zathura.enable = true;
    };
    home.packages = with pkgs; [
      virt-manager
      docker-credential-helpers

      # security
      # TODO: move to security.nix ?
      wireshark
      psmisc
    ];
  };
}
