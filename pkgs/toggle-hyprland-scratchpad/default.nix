{
  fd,
  fish,
  foot,
  hyprland,
  jq,
  lib,
  writeShellApplication,
}:
(writeShellApplication {
  name = "toggle-hyprland-scratchpad";
  runtimeInputs = [
    fd
    fish
    foot
    hyprland
    jq
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
