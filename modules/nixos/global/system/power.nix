{ config
, lib
, pkgs
, ...
}:
let
  inherit (config.nixos.custom.power.wol) phyname;
  inherit (config.nixos.custom.power.wakeup) devices;
  lidConfig = config.nixos.custom.power.wakeup.lid;
  lidName = lidConfig.name;
  actionAction = lidConfig.action;
  extraUdevRules = map
    (
      d:
      ''ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="${d.idVendor}", ATTRS{idProduct}=="${d.idProduct}", ATTR{power/wakeup}="${d.action}"''
    )
    devices;
in
{
  systemd.services = lib.mkIf (lidName != "") {
    "${actionAction}-${lidName}" = lib.mkIf (lidName != null) {
      wantedBy = [ "multi-user.target" ];
      description = "${actionAction} wakeup on opening LID0";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe pkgs.sync-lid} ${actionAction} ${lidName}";
      };
    };

    "wol@${phyname}" = lib.mkIf (phyname != null) {
      wantedBy = [ "multi-user.target" ];
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
