{ config
, lib
, pkgs
, ...
}:
let
  lid = config.nixos.custom.power.lid.name;
  action = config.nixos.custom.power.lid.action;
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
}
