{ config
, lib
, pkgs
, ...
}:
let
  phyname = config.nixos.custom.power.wol.phyname;
  lid = config.nixos.custom.power.wakeup.lid.name;
  action = config.nixos.custom.power.wakeup.lid.action;
  devices = config.nixos.custom.power.wakeup.devices;
  extraUdevRules = map
    (
      d:
      ''ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="${d.idVendor}", ATTRS{idProduct}=="${d.idProduct}", ATTR{power/wakeup}="${d.action}"''
    )
    devices;
in
{
  systemd.services = lib.mkIf (lid != null) {
    "${action}-${lid}" = lib.mkIf (lid != null) {
      wantedBy = [ "multi-user.target" ];
      description = "${action} wakeup on opening LID0";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe pkgs.sync-lid} ${action} ${lid}";
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
