{
  lib,
  writeShellApplication,
  wallpaper,
  sway,
  swayimg,
  coreutils,
  procps,
  swaylock,
}:
(writeShellApplication {
  name = "lock-screen";
  runtimeInputs = [
    wallpaper
    sway
    swayimg
    coreutils
    procps
    swaylock
  ];
  text = builtins.readFile ./lock-screen.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
