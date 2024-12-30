{
  config,
  lib,
  pkgs,
  ...
}: let
  feature_name = "laptop";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  config = {
    networking = lib.mkIf enabled {
      networkmanager = {
        enable = true;
        plugins = lib.mkForce [];
      };
    };

    boot = lib.mkIf enabled {
      kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_zen;
      binfmt.emulatedSystems = lib.mkIf (pkgs.hostPlatform == "x86_64-linux") [
        "aarch64-linux"
        "i686-linux"
      ];
      initrd.systemd.enable = true;
    };

    services = lib.mkIf enabled {
      upower.enable = lib.mkDefault true;
      thermald.enable = lib.mkDefault (pkgs.hostPlatform == "x86_64-linux");
    };

    powerManagement.powertop.enable = enabled;

    environment.systemPackages = with pkgs;
      lib.optionals enabled [
        linuxKernel.packages.linux_zen.perf
        powertop
      ];

    nixos.custom.features.register = feature_name;
  };
}
