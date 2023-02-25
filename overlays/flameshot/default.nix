self: super: {
  flameshot = super.symlinkJoin {
    name = "flameshot";
    paths = [ super.flameshot ];
    buildInputs = [ super.makeWrapper ];

    postBuild =
      if self.stdenv.isDarwin then ''
        makeWrapper $out/bin/${super.flameshot.pname}.app/Contents/MacOS/${super.flameshot.pname} $out/bin/${super.flameshot.pname}
      ''
      else "";
  };
}
