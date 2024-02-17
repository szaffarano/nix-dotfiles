{ config, lib, ... }:
let cfg = config.nixos.bluetooth;
in {
  options.nixos.bluetooth.enable = lib.mkEnableOption "bluetooth";

  config = lib.mkIf cfg.enable {
    # more info https://wiki.archlinux.org/title/bluetooth_mouse
    systemd.tmpfiles.rules = [
      "w    /sys/kernel/debug/bluetooth/hci0/conn_latency          -    -    -    -   0"
      "w    /sys/kernel/debug/bluetooth/hci0/conn_min_interval     -    -    -    -   6"
      "w    /sys/kernel/debug/bluetooth/hci0/conn_max_interval     -    -    -    -   9"
    ];

    services.blueman.enable = true;

    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            FastConnectable = true;
            Experimental = true;
            ControllerMode = "dual";
          };
          Policy = {
            ReconnectAttempts = 7;
            ReconnectIntervals = "1, 2, 4, 8, 16, 32, 64";
            AutoEnable = true;
          };
        };
      };
    };
  };
}
