{ config, lib, ... }:
let
  feature_name = "sensible";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  config = {
    services = lib.mkIf enabled {
      openssh.enable = true;
      tailscale.enable = true;
      fwupd.enable = true;
    };

    networking = lib.mkIf enabled { domain = "zaffarano.com.ar"; };

    boot.kernel.sysctl = lib.mkIf enabled {
      "fs.inotify.max_user_watches" = 512000;
      "fs.inotify.max_queued_events" = 512000;
    };

    zramSwap.enable = enabled;

    nixos.custom.features.register = feature_name;
  };
}
