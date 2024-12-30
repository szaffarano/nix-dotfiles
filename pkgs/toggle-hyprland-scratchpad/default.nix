{
  lib,
  writeShellApplication,
  fd,
  hyprland,
  foot,
  jq,
}:
(writeShellApplication {
  name = "toggle-hyprland-scratchpad";
  runtimeInputs = [
    fd
    foot
    jq
    hyprland
  ];
  text = builtins.readFile ./toggle-hyprland-scratchpad.sh;
})
// {
  meta = with lib; {
    mainProgram = "toggle-hyprland-scratchpad";
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
