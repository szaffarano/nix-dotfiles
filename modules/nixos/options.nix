{ lib, ... }:
{
  options = with lib; {
    nixos.custom = {
      debug = mkEnableOption "debug NixOS";
      quietboot = mkEnableOption "quiet boot options";
    };
  };
}
