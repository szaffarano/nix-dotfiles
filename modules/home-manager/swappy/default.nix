{ ... }:
{ config, lib, pkgs, ... }: {
  options.swappy.enable = lib.mkEnableOption "swappy";

  config = lib.mkIf config.swappy.enable {

    xdg.configFile."swappy/config".source = ./config;

    home.packages = with pkgs; [ swappy ];
  };
}
