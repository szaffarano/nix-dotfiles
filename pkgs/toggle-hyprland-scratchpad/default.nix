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
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
