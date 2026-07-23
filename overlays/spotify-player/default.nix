final: prev: {
  spotify-player = prev.spotify-player.overrideAttrs (_: rec {
    pname = "spotify-player";
    version = "0.24.1";
    src = prev.fetchFromGitHub {
      owner = "aome510";
      repo = "spotify-player";
      tag = "v${version}";
      hash = "sha256-+GADmRl4XMwV8TfYZjEeyKDDfda3bDPzeerhYryX6vA=";
    };
    patches = [];
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-CSZ5sZ+d7Jhi43ipaWXKupYPFgWCbCx4RMTQN8emu9o=";
    };
  });
}
