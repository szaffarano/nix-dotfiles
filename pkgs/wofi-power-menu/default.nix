{ lib, writeShellApplication, systemd, wofi, sway }:
(writeShellApplication {
  name = "wofi-power-menu";
  runtimeInputs = [ systemd wofi sway ];
  text = builtins.readFile ./wofi-power-menu.sh;
}) // {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
