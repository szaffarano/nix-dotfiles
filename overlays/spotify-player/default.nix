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
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-YarKRApcQHom3AQIirqGdmUOuy5B+BRehLijvF/GRPc=";
    };
  });
}
