self: super: {
  kitty = super.symlinkJoin {
    name = "kitty";
    paths = [ super.kitty ];
    buildInputs = [ super.makeWrapper super.pkgs.nixgl.nixGLIntel ];
    postBuild = ''
      mv $out/bin/kitty $out/bin/kitty.ok

      echo "${super.pkgs.nixgl.nixGLIntel}/bin/nixGLIntel $out/bin/kitty.ok \$@" > $out/bin/kitty

      chmod +x $out/bin/kitty
    '';
  };
}
