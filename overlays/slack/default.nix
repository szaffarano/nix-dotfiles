self: super: {
  slack = super.symlinkJoin {
    name = "slack";
    paths = [ super.slack ];
    buildInputs = [ super.makeWrapper super.pkgs.nixgl.nixGLIntel ];
    postBuild = ''
      mv $out/bin/slack $out/bin/slack.ok

      echo "${super.pkgs.nixgl.nixGLIntel}/bin/nixGLIntel $out/bin/slack.ok" > $out/bin/slack

      chmod +x $out/bin/slack

      wrapProgram $out/bin/slack
    '';
  };
}
