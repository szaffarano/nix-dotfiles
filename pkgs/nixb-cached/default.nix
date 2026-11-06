{
  lib,
  writeShellApplication,
  nh,
  nix,
  cachix,
}:
(writeShellApplication {
  name = "nixb-cached";
  runtimeInputs = [nh nix cachix];
  text = builtins.readFile ./nixb-cached.sh;
})
// {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
