{
  lib,
  writeShellApplication,
  coreutils,
}:
(writeShellApplication {
  name = "sync-lid";
  runtimeInputs = [coreutils];
  text = builtins.readFile ./sync-lid.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    mainProgram = "sync-lid";
    platforms = platforms.all;
  };
}
