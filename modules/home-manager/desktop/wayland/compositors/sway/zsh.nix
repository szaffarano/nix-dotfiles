{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.programs.zsh.enable {
    programs.zsh.loginExtra =
      lib.strings.optionalString config.wayland.windowManager.sway.enable ''
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
          exec ${lib.getExe config.wayland.windowManager.sway.package} \
            > ~/.cache/sway.log 2>~/.cache/sway.err.log
        fi
      ''
      + (lib.strings.optionalString config.wayland.windowManager.hyprland.enable ''
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
          exec ${lib.getExe pkgs.hyprland} \
            > ~/.cache/hyprland.log 2>~/.cache/hyprland.err.log
        fi
      '');
  };
}
