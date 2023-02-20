_:
{ config, lib, pkgs, ... }: {
  options.NAME.enable = lib.mkEnableOption "NAME";

  config = lib.mkIf config.NAME.enable {
    programs.NAME = {
      enable = true;
    };
  };
}
