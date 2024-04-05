{ config, lib, ... }:
let
  cfg = config.nixos.quietboot;
in
{
  options.nixos.quietboot.enable = lib.mkEnableOption "quiet boot";

  config = lib.mkIf cfg.enable {
    console = {
      useXkbConfig = true;
      earlySetup = false;
    };

    boot = {
      plymouth = {
        enable = true;
        theme = "spinner";
      };
      loader.timeout = 3;
      kernelParams = [
        "quiet"
        "loglevel=3"
        "systemd.show_status=auto"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "vt.global_cursor_default=0"
      ];
      consoleLogLevel = lib.mkDefault 0;
      initrd.verbose = false;
    };
  };
}
