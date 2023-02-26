{ ... }:
{ config, lib, pkgs, ... }: {
  options.copyq.enable = lib.mkEnableOption "copyq";

  config = lib.mkIf config.copyq.enable {

    xdg.configFile."copyq/copyq.conf".source = config.lib.file.mkOutOfStoreSymlink ./config/copyq.conf;
    xdg.configFile."copyq/copyq-commands.ini".source = config.lib.file.mkOutOfStoreSymlink ./config/copyq-commands.ini;

    home.packages = with pkgs; [ copyq ];
  };
}
