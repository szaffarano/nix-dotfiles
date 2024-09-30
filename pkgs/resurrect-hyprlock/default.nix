{ lib
, writeShellApplication
, hyprland
, systemd
, coreutils
, util-linux
,
}:
(writeShellApplication {
  name = "resurrect-hyprlock";
  runtimeInputs = [
    hyprland
    systemd
    coreutils
    util-linux
  ];
  text = builtins.readFile ./resurrect-hyprlock.sh;
})
  // {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
