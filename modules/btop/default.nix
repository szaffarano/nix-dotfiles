_:
{ config, lib, pkgs, theme, ... }:

{
  options.btop.enable = lib.mkEnableOption "btop";

  config = lib.mkIf config.btop.enable {

    programs.btop = {
      enable = true;

      settings = {
        theme_background = false;
        vim_keys = true;
        proc_tree = true;
      };
    };
  };
}
