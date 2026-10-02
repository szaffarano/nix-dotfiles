{
  config,
  lib,
  pkgs,
  ...
}: let
  feature_name = "embedded";
  enabled = builtins.elem feature_name config.nixos.custom.features.enable;

  embeddedUdevRules = pkgs.writeTextFile {
    name = "embedded-udev-rules";
    destination = "/etc/udev/rules.d/70-embedded.rules";
    text = ''
      # BBC micro:bit v2 — onboard DAPLink CMSIS-DAP (probe-rs / cargo embed)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0d28", ATTRS{idProduct}=="0204", TAG+="uaccess"
      # BBC micro:bit v2 — CDC-ACM serial console (minicom)
      SUBSYSTEM=="tty", ATTRS{idVendor}=="0d28", ATTRS{idProduct}=="0204", TAG+="uaccess"

      # Raspberry Pi Debug Probe — CMSIS-DAP (probe-rs)
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="000c", TAG+="uaccess"
      # Raspberry Pi RP2040/RP2350 — USB serial console from firmware (minicom)
      SUBSYSTEM=="tty", ATTRS{idVendor}=="2e8a", TAG+="uaccess"
    '';
  };
in {
  config = {
    services.udev = lib.mkIf enabled {
      # RP2040 / RP2350 BOOTSEL (picotool / UF2) — ships 60-picotool.rules
      packages = [pkgs.picotool embeddedUdevRules];
    };

    nixos.custom.features.register = feature_name;
  };
}
