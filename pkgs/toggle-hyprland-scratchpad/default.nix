{ lib
, writeShellApplication
, fd
, hyprland
, wezterm
, jq
,
}:
(writeShellApplication {
  name = "toggle-hyprland-scratchpad";
  runtimeInputs = [
    fd
    wezterm
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
