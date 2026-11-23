{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.xorg.xautolock;
in
  with lib; {
    options.desktop.xorg.xautolock.enable = mkEnableOption "screen locker (xss-lock + xautolock)";

    config = mkIf cfg.enable {
      services.screen-locker = let
        graceSecs = 5;
        lockWithGrace = pkgs.writeShellScript "lock-with-grace" ''
          img=''$(${lib.getExe pkgs.wallpaper})

          ${pkgs.feh}/bin/feh --auto-zoom --fullscreen --hide-pointer --borderless --no-menus "$img" &
          overlay=$!

          start=$(${pkgs.coreutils}/bin/date +%s%3N)
          while :; do
            now=$(${pkgs.coreutils}/bin/date +%s%3N)
            elapsed=$((now - start))
            idle=$(${pkgs.xprintidle}/bin/xprintidle)
            # Idle time below the elapsed time means input happened during the grace period.
            if [ "$idle" -lt "$elapsed" ]; then
              kill "$overlay" 2>/dev/null
              exit 0
            fi
            [ "$elapsed" -ge ${toString (graceSecs * 1000)} ] && break
            sleep 0.1
          done

          kill "$overlay" 2>/dev/null
          wait "$overlay" 2>/dev/null
          exec ${pkgs.i3lock-color}/bin/i3lock-color -i "$img" --color ${config.colorScheme.palette.base00}
        '';
      in {
        enable = true;
        inactiveInterval = 5;
        lockCmd = "${lockWithGrace}";
        xautolock.enable = true;
        xautolock.detectSleep = true;
      };
    };
  }
