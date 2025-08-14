{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.nixos.custom.power.wol) phyname;
  inherit (config.nixos.custom.power.wakeup) devices;
  lidConfig = config.nixos.custom.power.wakeup.lid;
  lidName = lidConfig.name;
  actionAction = lidConfig.action;
  extraUdevRules =
    map (
      d: ''ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="${d.idVendor}", ATTRS{idProduct}=="${d.idProduct}", ATTR{power/wakeup}="${d.action}"''
    )
    devices;
in {
  environment.systemPackages = with pkgs;
    [
      fwupd
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isx86 [
      libsmbios
    ];

  services = {
    tlp = {
      enable = true;
      settings = {
        # Default mode (auto-switch)
        TLP_DEFAULT_MODE = "AC";
        TLP_PERSISTENT_DEFAULT = 0;

        # CPU scaling
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        # Intel P-state performance limits
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 20;
        CPU_MAX_PERF_ON_BAT = 60;

        # Turbo Boost
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        # Platform profile
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced";

        # Disk and PCIe
        DISK_APM_LEVEL_ON_AC = 254;
        DISK_APM_LEVEL_ON_BAT = 128;
        SATA_LINKPWR_ON_AC = "max_performance";
        SATA_LINKPWR_ON_BAT = "min_power";
        PCIE_ASPM_ON_AC = "performance";
        PCIE_ASPM_ON_BAT = "powersave";

        # USB autosuspend
        USB_AUTOSUSPEND = 0;

        # Runtime power management
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";

        # Dell SMBIOS battery thresholds (BIOS-level)
        START_CHARGE_THRESH_BAT0 = 50;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
  systemd.services = lib.mkIf (lidName != "") {
    thermald.enable = true;
    powerManagement.enable = true;

    "${actionAction}-${lidName}" = lib.mkIf (lidName != null) {
      wantedBy = ["multi-user.target"];
      description = "${actionAction} wakeup on opening LID0";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe pkgs.sync-lid} ${actionAction} ${lidName}";
      };
    };

    "wol@${phyname}" = lib.mkIf (phyname != null) {
      wantedBy = ["multi-user.target"];
      description = "Wake-on-LAN for ${phyname}";
      unitConfig = {
        Requires = "network.target";
        After = "network.target";
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe pkgs.iw} ${phyname} wowlan enable magic-packet";
      };
    };
  };

  services = {
    udev.extraRules = lib.concatStringsSep "\n" extraUdevRules;
  };
}
