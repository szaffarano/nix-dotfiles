{ config
, lib
, pkgs
, ...
}:
let
  phyname = config.nixos.custom.wol.phyname;
in
{
  systemd.services = lib.mkIf (phyname != null) {
    "wol@${phyname}" = {
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
}
