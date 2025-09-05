final: prev: {
  spotify-player = prev.spotify-player.overrideAttrs (_: rec {
    pname = "spotify-player";
    version = "0.21.0";
    src = prev.fetchFromGitHub {
      owner = "aome510";
      repo = "spotify-player";
      rev = "v${version}";
      hash = "sha256-nOswrYt9NrzJV6CFBWZCpj/wIJnIgmr3i2TreAKGGPI=";
    };
    patches = [
      (prev.fetchpatch {
        name = "fix-build-failure.patch";
        url = "https://github.com/aome510/spotify-player/commit/77af13b48b2a03e61fef1cffea899929057551dc.patch";
        hash = "sha256-5q8W0X49iZLYdwrBiZJTESb628VPamrm0zEYwDm8CVk=";
      })
    ];
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-YarKRApcQHom3AQIirqGdmUOuy5B+BRehLijvF/GRPc=";
    };
  });
}
