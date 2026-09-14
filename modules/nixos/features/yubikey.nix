{
  config,
  lib,
  pkgs,
  ...
}: let
  feature_name = "yubikey";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;

  touchSound = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/message.oga";

  touchSoundScript = pkgs.writeShellScript "yubikey-touch-sound" ''
    set -euo pipefail
    socket="''${XDG_RUNTIME_DIR}/yubikey-touch-detector.socket"
    ${pkgs.socat}/bin/socat -u "UNIX-CONNECT:''${socket}" - | while read -r -n5 msg; do
      case "$msg" in
        *_1) ${pkgs.pipewire}/bin/pw-play "${touchSound}" || true ;;
      esac
    done
  '';
in {
  config = {
    services = lib.mkIf enabled {
      pcscd = {
        enable = true;
        plugins = with pkgs; [ccid];
      };
      udev.packages = with pkgs; [yubikey-personalization];
    };

    programs.yubikey-touch-detector = lib.mkIf enabled {
      enable = true;
      libnotify = true;
      unixSocket = true;
    };

    systemd.user.services.yubikey-touch-sound = lib.mkIf enabled {
      description = "Play a sound when the YubiKey is waiting for a touch";
      after = ["yubikey-touch-detector.socket"];
      requires = ["yubikey-touch-detector.socket"];
      partOf = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        ExecStart = touchSoundScript;
        Restart = "on-failure";
        RestartSec = 2;
      };
    };

    environment.systemPackages = with pkgs; lib.mkIf enabled [pcsc-tools];

    nixos.custom.features.register = feature_name;
  };
}
