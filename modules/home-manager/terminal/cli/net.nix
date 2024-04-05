{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.terminal.cli.net;
in
with lib;
{
  options.terminal.cli.net.enable = mkEnableOption "net";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dig
      netcat-gnu
      ethtool
      iw
      bandwhich # Terminal bandwidth utilization tool
      nettools
      whois
    ];
  };
}
