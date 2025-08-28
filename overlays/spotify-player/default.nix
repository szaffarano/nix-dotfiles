final: prev: {
  spotify-player = let
    spotifyPlayerSrc = prev.fetchFromGitHub {
      owner = "aome510";
      repo = "spotify-player";
      rev = "bd38dd05a3c52107f76665dc88002e5a0815d095";
      hash = "sha256-DCIZHAfI3x9I6j2f44cDcXbMpZbNXJ62S+W19IY6Qus=";
    };
    librespotSrc = prev.stdenv.mkDerivation {
      name = "librespot-patched-src";
      src = prev.fetchFromGitHub {
        owner = "librespot-org";
        repo = "librespot";
        rev = "c715885747a95ec22f9502825cb0d2d8833c3779";
        hash = "sha256-B/GoRIwnqd4c/2PXNsr1bDqsLmI1dbqIo1K/azox+XU=";
      };

      installPhase = "cp -r . $out";
    };

    spotifyPlayerPatchedSrc = prev.runCommand "spotify-player-patched-src" {} ''
      cp -r ${spotifyPlayerSrc} $out
      chmod -R +w $out

      cd $out
      patch -p1 < ${prev.writeText "use-local-librespot.patch" ''
        diff --git a/spotify_player/Cargo.toml b/spotify_player/Cargo.toml
        index a5c812d..8c8532d 100644
        --- a/spotify_player/Cargo.toml
        +++ b/spotify_player/Cargo.toml
        @@ -15,11 +15,11 @@ clap = { version = "4.5.41", features = ["derive", "string"] }
         config_parser2 = "0.1.6"
         crossterm = "0.29.0"
         dirs-next = "2.0.0"
        -librespot-connect = { version = "0.7.0", optional = true }
        -librespot-core = "0.7.0"
        -librespot-oauth = "0.7.0"
        -librespot-playback = { version = "0.7.0", optional = true }
        -librespot-metadata = "0.7.0"
        +librespot-connect = { path = "${librespotSrc}/connect", optional = true }
        +librespot-core = { path = "${librespotSrc}/core" }
        +librespot-oauth = { path = "${librespotSrc}/oauth" }
        +librespot-playback = { path = "${librespotSrc}/playback", optional = true }
        +librespot-metadata = { path = "${librespotSrc}/metadata" }
         log = "0.4.27"
         chrono = "0.4.41"
         reqwest = { version = "0.12.22", features = ["json"] }
      ''}
    '';
  in
    prev.spotify-player.overrideAttrs (_: rec {
      pname = "spotify-player";
      version = "0.21.0-librespot-dev";
      src = spotifyPlayerPatchedSrc;
      cargoDeps = final.rustPlatform.fetchCargoVendor {
        inherit src;
        hash = "sha256-fNDztl0Vxq2fUzc6uLNu5iggNRnRB2VxzWm+AlSaoU0=";
      };
    });
}
