{ config, lib, pkgs, ... }: {
  options.zathura.enable = lib.mkEnableOption "zathura";

  config = lib.mkIf config.zathura.enable {
    programs.zathura = {
      enable = true;
      options.selection-clipboard = "clipboard";
    };
  };
}
