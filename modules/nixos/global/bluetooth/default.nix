{ config, lib, pkgs, ... }:
let cfg = config.nixos.bluetooth;
in {
  options.nixos.bluetooth.enable = lib.mkEnableOption "bluetooth";

  config = lib.mkIf cfg.enable {
    # more info https://wiki.archlinux.org/title/bluetooth_mouse
    systemd.tmpfiles = {
      settings = {
        "100-bluetooth_latency" = {
          "/sys/kernel/debug/bluetooth/hci0/conn_latency" = {
            w = { argument = "0"; };
          };
          "/sys/kernel/debug/bluetooth/hci0/conn_min_interval" = {
            w = { argument = "15"; };
          };
          "/sys/kernel/debug/bluetooth/hci0/conn_max_interval" = {
            w = { argument = "30"; };
          };
        };
      };
    };

    services.blueman.enable = true;

    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        package = pkgs.bluez5-experimental;
        settings = {
          General = {
            FastConnectable = true;
            Experimental = true;
            KernelExperimental = true;
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
