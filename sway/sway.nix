{
  lib,
  config,
}: {
  enable = true;
  swaynag.enable = true;
  config = {
    modifier = "Mod4";
    terminal = "foot";
    menu = "rofi -show drun";
    startup = [
    ];
    assigns = {
    };
    keybindings = let
      mod = config.wayland.windowManager.sway.config.modifier;
    in
      lib.mkOptionDefault {
        "${mod}+q" = "exec --no-startup-id rofi -show window";
        "${mod}+F2" = "exec --no-startup-id rofi -show run";
      };
  };
}
