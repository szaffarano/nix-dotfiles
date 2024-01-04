{ config, lib, ... }:
with lib; {

  options.ssh.enable = mkEnableOption "ssh";

  config = mkIf config.ssh.enable { programs.ssh = { enable = true; }; };
}
