{ lib
, writeShellApplication
, fd
, sway
, foot
, jq
,
}:
(writeShellApplication {
  name = "toggle-sway-scratchpad";
  runtimeInputs = [
    fd
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
  };
}
