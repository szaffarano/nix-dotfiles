# https://github.com/danyspin97/wpaperd/issues/79
_final: prev: {
  wpaperd = prev.wpaperd.overrideAttrs (old: rec {
    version = "1.0.2-dev";
    src = prev.fetchFromGitHub {
      owner = "danyspin97";
      repo = "wpaperd";
      rev = "a60671eb5b7029095ad387d06c051b547778fc55";
      hash = "sha256-7lf5gcbLC7h+bfxGQGRc92pIb46UWsZCvN6CJrRJB4U=";
    };
    cargoDeps = old.cargoDeps.overrideAttrs (
      prev.lib.const {
        inherit src;
        outputHash = "sha256-cZPu0XdYMPc7W9CLOL0FdveQ/KPmj6yXb0zTGuYNtkE=";
      }
    );
  });
}
