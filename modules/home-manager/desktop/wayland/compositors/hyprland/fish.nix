{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.programs.fish.enable
    && config.wayland.windowManager.hyprland.enable) {
    programs.fish.loginShellInit = ''
      set TTY1 (tty)
      [ "$TTY1" = "/dev/tty1" ] && exec \
        exec ${lib.getExe config.wayland.windowManager.hyprland.package} \
          > ~/.cache/hyprland.log 2>~/.cache/hyprland.err.log
    '';
  };
}
