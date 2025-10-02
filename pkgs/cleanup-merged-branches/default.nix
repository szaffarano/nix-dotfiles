{
  lib,
  writeShellApplication,
  coreutils,
  gh,
  git,
}:
(writeShellApplication {
  name = "cleanup-merged-branches";
  runtimeInputs = [coreutils gh git];
  text = builtins.readFile ./cleanup-merged-branches.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
