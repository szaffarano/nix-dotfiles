{ config, lib, pkgs, ... }: {
  imports = [ ./cjbassi ./slithery0 ];
  options.waybar.enable = lib.mkEnableOption "waybar";

  config = lib.mkIf config.waybar.enable {
    cjbassi.enable = false;
    slithery0.enable = true;

    wayland.windowManager.sway = {
      config.bars = [ ];
      extraConfigEarly = ''
        exec waybar
      '';
    };

    programs.waybar = { enable = true; };
  };
}
