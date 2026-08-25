{
  lib,
  writeShellApplication,
  coreutils,
  gh,
  git,
}:
(writeShellApplication {
  name = "git-cleanup-merged-branches";
  runtimeInputs = [coreutils gh git];
  text = builtins.readFile ./git-cleanup-merged-branches.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
    mainProgram = "git-cleanup-merged-branches";
  };
}
