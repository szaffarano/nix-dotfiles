{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.programs.hyprland.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # Allow wheel users to suspend/hibernate without an active logind session.
    # Needed because Hyprland's exec spawns children outside the session scope,
    # causing polkit to deny systemctl suspend/hibernate from keybindings.
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        var powerActions = [
          "org.freedesktop.login1.suspend",
          "org.freedesktop.login1.suspend-multiple-sessions",
          "org.freedesktop.login1.hibernate",
          "org.freedesktop.login1.hibernate-multiple-sessions",
          "org.freedesktop.login1.reboot",
          "org.freedesktop.login1.reboot-multiple-sessions",
          "org.freedesktop.login1.power-off",
          "org.freedesktop.login1.power-off-multiple-sessions",
        ];
        if (powerActions.indexOf(action.id) >= 0 && subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
