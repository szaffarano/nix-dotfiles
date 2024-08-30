{ lib
, writeShellApplication
, coreutils
, util-linux
,
}:
(writeShellApplication {
  name = "arch";
  runtimeInputs = [
    coreutils
    util-linux
  ];
  text = builtins.readFile ./arch.sh;
})
  // {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
