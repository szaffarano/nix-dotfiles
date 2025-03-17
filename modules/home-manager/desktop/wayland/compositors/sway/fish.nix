{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.programs.fish.enable {
    programs.fish.loginShellInit =
      ''
        set TTY1 (tty)
        [ "$TTY1" = "/dev/tty1" ] && exec \
          ${lib.getExe config.wayland.windowManager.sway.package} \
            > ~/.cache/sway.log 2>~/.cache/sway.err.log
      ''
      + (lib.strings.optionalString config.wayland.windowManager.hyprland.enable ''
        set TTY1 (tty)
        [ "$TTY1" = "/dev/tty1" ] && exec \
          ${lib.getExe pkgs.hyprland} \
            > ~/.cache/hyprland.log 2>~/.cache/hyprland.err.log
        fi
      '');
  };
}
