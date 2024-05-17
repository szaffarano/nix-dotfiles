{ config, lib, ... }:
{
  services.openssh = lib.mkIf config.services.openssh.enable {
    settings = lib.mkDefault {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.sshAgentAuth = lib.mkDefault {
    enable = true;
    authorizedKeysFiles = [ "/etc/ssh/authorized_keys.d/%u" ];
  };
}
