self: super: {
  chromium = super.symlinkJoin {
    name = "chromium";
    paths = [ super.chromium ];
    buildInputs = [ super.makeWrapper super.pkgs.nixgl.nixGLIntel ];
    postBuild = ''
      mv $out/bin/chromium $out/bin/chromium.ok

      echo "${super.pkgs.nixgl.nixGLIntel}/bin/nixGLIntel $out/bin/chromium.ok" > $out/bin/chromium

      chmod +x $out/bin/chromium

      wrapProgram $out/bin/chromium --add-flags "--start-maximized --ozone-platform-hint=auto --ignore-gpu-blocklist --enable-gpu-rasterization --enable-zero-copy"
    '';
  };
}
