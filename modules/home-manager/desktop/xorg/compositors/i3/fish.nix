{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.programs.fish.enable
    && config.xsession.windowManager.i3.enable) {
    programs.fish.loginShellInit = ''
      set TTY1 (tty)
      [ "$TTY1" = "/dev/tty1" ] && exec \
        ${pkgs.xorg.xinit}/bin/startx \
          > ~/.cache/xorg.log 2>~/.cache/xorg.err.log
    '';
  };
}
