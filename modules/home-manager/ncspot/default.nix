_:
{ config, lib, pkgs, ... }: {
  options.ncspot.enable = lib.mkEnableOption "ncspot";

  config = lib.mkIf config.ncspot.enable {
    programs.ncspot = {
      enable = true;
      package = pkgs.ncspot.override { withALSA = false; };
    };
  };
}
