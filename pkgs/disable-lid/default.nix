{ lib
, writeShellApplication
, coreutils
}:
(writeShellApplication {
  name = "disable-lid";
  runtimeInputs = [ coreutils ];
  text = builtins.readFile ./disable-lid.sh;
}) // {
  meta = with lib; {
    licenses = licenses.mit;
    platforms = platforms.all;
  };
}
