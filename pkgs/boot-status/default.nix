{
  lib,
  writeShellApplication,
  coreutils,
}:
(writeShellApplication {
  name = "boot-status";
  runtimeInputs = [coreutils];
  text = builtins.readFile ./boot-status.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
