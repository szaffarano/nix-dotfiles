{
  lib,
  writeShellApplication,
  curl,
  findutils,
  coreutils,
}:
(writeShellApplication {
  name = "wallpaper";
  runtimeInputs = [
    curl
    findutils
    coreutils
  ];
  text = builtins.readFile ./wallpaper.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
