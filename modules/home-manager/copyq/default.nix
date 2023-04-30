{ ... }:
{ config, lib, pkgs, ... }: {
  options.copyq.enable = lib.mkEnableOption "copyq";

  config = lib.mkIf config.copyq.enable {

    xdg.configFile."copyq/copyq.conf".source = ./config/copyq.conf;
    xdg.configFile."copyq/copyq-commands.ini".source = ./config/copyq-commands.ini;

    home.packages = with pkgs; [ copyq ];
  };
}
