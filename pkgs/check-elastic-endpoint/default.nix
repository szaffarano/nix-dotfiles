{
  lib,
  writeShellApplication,
  libnotify,
  procps,
}:
(writeShellApplication {
  name = "check-elastic-endpoint";
  runtimeInputs = [libnotify procps];
  text = builtins.readFile ./check-elastic-endpoint.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
    mainProgram = "check-elastic-endpoint";
  };
}
