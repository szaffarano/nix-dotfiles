{
  lib,
  writeShellApplication,
  curl,
  findutils,
  coreutils,
  bind,
}:
(writeShellApplication {
  name = "wallpaper";
  runtimeInputs = [
    curl
    findutils
    coreutils
    bind
  ];
  text = builtins.readFile ./wallpaper.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    mainProgram = "wallpaper";
    platforms = platforms.all;
  };
}
