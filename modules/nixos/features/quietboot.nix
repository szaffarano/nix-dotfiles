{ config, lib, ... }:
let
  feature_name = "quietboot";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  config = {
    console = lib.mkIf enabled {
      useXkbConfig = true;
      earlySetup = false;
    };

    boot = lib.mkIf enabled {
      plymouth = {
        enable = lib.mkDefault true;
        theme = lib.mkDefault "spinner";
      };
      loader.timeout = lib.mkDefault 3;
      kernelParams = lib.mkDefault [
        "quiet"
        "loglevel=3"
        "systemd.show_status=auto"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "vt.global_cursor_default=0"
      ];
      consoleLogLevel = lib.mkDefault 0;
      initrd.verbose = lib.mkDefault false;
    };

    nixos.custom.features.register = feature_name;
  };
}
