{
  lib,
  writeShellApplication,
  fd,
  sway,
  wezterm,
  jq,
}:
(writeShellApplication {
  name = "toggle-sway-scratchpad";
  runtimeInputs = [
    fd
    wezterm
    jq
    sway
  ];
  text = builtins.readFile ./toggle-sway-scratchpad.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
