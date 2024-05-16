{ config
, lib
, pkgs
, ...
}:
let
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
  };
  services = {
    udev.extraRules = lib.concatStringsSep "\n" extraUdevRules;
  };
}
