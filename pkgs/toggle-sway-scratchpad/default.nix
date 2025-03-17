{
  fd,
  fish,
  foot,
  jq,
  lib,
  sway,
  writeShellApplication,
}:
(writeShellApplication {
  name = "toggle-sway-scratchpad";
  runtimeInputs = [
    fd
    fish
    foot
    jq
    sway
  ];
  text = builtins.readFile ./toggle-sway-scratchpad.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
    mainProgram = "toggle-sway-scratchpad";
  };
}
