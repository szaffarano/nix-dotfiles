{
  lib,
  pkgs,
  python3Packages,
}:
python3Packages.buildPythonPackage rec {
  pname = "cliphist-to-wofi";
  version = "0.1.1";
  pyproject = true;

  src = ./.;

  build-system = with python3Packages; [hatchling];

  dependencies = with pkgs; [
    cliphist
    imagemagick
    wofi
  ];

  meta = {
    description = "cliphist wofi integration";
    mainProgram = pname;
    license = lib.licenses.mit;
  };
}
