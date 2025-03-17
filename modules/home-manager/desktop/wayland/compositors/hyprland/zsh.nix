{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.programs.zsh.enable && config.wayland.windowManager.hyprland.enable) {
    programs.zsh.loginExtra = ''
      if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec ${lib.getExe config.wayland.windowManager.hyprland.package} \
          > ~/.cache/hyprland.log 2>~/.cache/hyprland.err.log
      fi
    '';
  };
}
