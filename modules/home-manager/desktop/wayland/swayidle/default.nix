{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.wayland.swayidle;

  lockScreen = "${pkgs.lock-screen}/bin/lock-screen";
  pgrep = "${pkgs.procps}/bin/pgrep";
  swaymsg = lib.getExe pkgs.sway;

  isLocked = "${pgrep} -x swaylock";

  # Makes two timeouts: one for when the screen is not locked (lockTime+timeout) and one for when it is.
  # Thanks Misterio77! :)
  afterLockTimeout = {
    timeout,
    command,
    resumeCommand ? null,
  }: [
    {
      timeout = cfg.lockTime + timeout;
      inherit command resumeCommand;
    }
    {
      command = "${isLocked} && ${command}";
      inherit resumeCommand timeout;
    }
  ];
in
  with lib; {
    options.desktop.wayland.swayidle = {
      enable = mkEnableOption "swayidle";
      lockTime = mkOption {
        type = types.int;
        default = 5 * 60;
        description = "Time in seconds before the screen is locked.";
      };
    };

    config = mkIf cfg.enable {
      services.swayidle = {
        enable = true;
        systemdTarget = "graphical-session.target";
        events =
          {
            "before-sleep" = "${lockScreen} 0";
          }
          // (lib.optionals config.wayland.windowManager.sway.enable {
            "lock" = "${lockScreen} 0";
          });
        timeouts =
          # Lock screen
          [
            {
              timeout = cfg.lockTime;
              command = lockScreen;
            }
          ]
          ++
          # Turn off displays (hyprland)
          (lib.optionals config.wayland.windowManager.hyprland.enable (
            afterLockTimeout (
              let
                hyprctl = lib.getExe config.wayland.windowManager.hyprland.package;
              in {
                timeout = 60;
                command = "${hyprctl} dispatch dpms off";
                resumeCommand = "${hyprctl} dispatch dpms on";
              }
            )
          ))
          ++
          # Turn off displays (sway)
          (lib.optionals config.wayland.windowManager.sway.enable (afterLockTimeout {
            timeout = 60;
            command = "${swaymsg} 'output * dpms off'";
            resumeCommand = "${swaymsg} 'output * dpms on'";
          }));
      };
    };
  }
