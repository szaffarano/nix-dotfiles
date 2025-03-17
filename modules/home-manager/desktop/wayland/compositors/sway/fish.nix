{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.programs.fish.enable
    && config.wayland.windowManager.sway.enable) {
    programs.fish.loginShellInit = ''
      set TTY1 (tty)
      [ "$TTY1" = "/dev/tty1" ] && exec \
        ${lib.getExe config.wayland.windowManager.sway.package} \
          > ~/.cache/sway.log 2>~/.cache/sway.err.log
    '';
  };
}
