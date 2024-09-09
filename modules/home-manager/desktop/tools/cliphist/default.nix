{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.desktop.tools.cliphist;
in
with lib;
{

  options.desktop.tools.cliphist.enable = mkEnableOption "cliphist";

  config =
    let
      wlPaste = "${pkgs.wl-clipboard}/bin/wl-paste";
      watchTxtCmd = "${wlPaste} --type text --watch cliphist store";
      watchImgCmd = "${wlPaste} --type image --watch cliphist store";
    in
    mkIf cfg.enable {
      home.packages = with pkgs; [ cliphist ];

      wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
        startup = [
          { command = watchTxtCmd; }
          { command = watchImgCmd; }
        ];
      };

      wayland.windowManager.hyprland.settings =
        lib.mkIf config.desktop.wayland.compositors.hyprland.enable
          {
            bind = [
              "CTRL_ALT,v,exec,${pkgs.cliphist-to-wofi}/bin/cliphist-to-wofi | ${pkgs.wl-clipboard}/bin/wl-copy"
            ];
            exec = [
              watchTxtCmd
              watchImgCmd
            ];
          };
    };
}
