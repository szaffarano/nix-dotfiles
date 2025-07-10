{
  lib,
  writeShellApplication,
  coreutils,
}:
(writeShellApplication {
  name = "get-keepass-entry";
  runtimeInputs = [coreutils];
  text = builtins.readFile ./get-keepass-entry.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
