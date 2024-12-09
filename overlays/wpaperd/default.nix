# https://github.com/danyspin97/wpaperd/issues/79
_final: prev: {
  wpaperd = prev.wpaperd.overrideAttrs (old: rec {
    version = "1.0.2-dev";
    src = prev.fetchFromGitHub {
      owner = "danyspin97";
      repo = "wpaperd";
      rev = "459c4e9c8bdd0f8b0572751efc96b59a2dd4cc78";
      hash = "sha256-Jd/+JMMn1lgm1Oe78du6DVkFWGCWvbNuSXsIKzcCeME=";
    };
    cargoDeps = old.cargoDeps.overrideAttrs (
      prev.lib.const {
        inherit src;
        outputHash = "sha256-GEhD15shAGyLZXUndoaUTz8d5mNpOHapQJTP3RZ0dqM=";
      }
    );
  });
}
