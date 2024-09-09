{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.desktop.tools.cliphist;
  safeStore = pkgs.writeShellApplication {
    name = "safe-cliphist-store";
    runtimeInputs = with pkgs; [ cliphist ];
    text = builtins.readFile ./safe-cliphist-store.sh;
  };
in
with lib;
{
  options.desktop.tools.cliphist.enable = mkEnableOption "cliphist";

  config =
    let
      wlPaste = "${pkgs.wl-clipboard}/bin/wl-paste";
      watchTxtCmd = "${wlPaste} --type text --watch ${lib.getExe safeStore}";
      watchImgCmd = "${wlPaste} --type image --watch ${lib.getExe safeStore}";
      wofiCmd = "${pkgs.cliphist-to-wofi}/bin/cliphist-to-wofi";
      clipCmd = lib.getExe pkgs.cliphist;
    in
    mkIf cfg.enable {
      home.packages = with pkgs; [
        cliphist
        wl-clipboard
      ];

      wayland.windowManager.sway.config = lib.mkIf config.desktop.wayland.compositors.sway.enable {
        startup = [
          { command = watchTxtCmd; }
          { command = watchImgCmd; }
        ];
        keybindings = {
          "Ctrl+Alt+v" = "${wofiCmd} | ${clipCmd} decode | ${pkgs.wl-clipboard}/bin/wl-copy";
          "Ctrl+Alt+Shift+V" = "${wofiCmd} | ${clipCmd} delete";
        };
      };

      wayland.windowManager.hyprland.settings =
        lib.mkIf config.desktop.wayland.compositors.hyprland.enable
          {
            bind = [
              "CTRL_ALT,v,exec,${wofiCmd} | ${clipCmd} decode | ${pkgs.wl-clipboard}/bin/wl-copy"
              "CTRL_ALT_SHIFT,v,exec,${wofiCmd} 'Delete clip' | ${clipCmd} delete"
            ];
            exec = [
              watchTxtCmd
              watchImgCmd
            ];
          };
    };
}
