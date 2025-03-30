# https://github.com/danyspin97/wpaperd/issues/115
final: prev: {
  wpaperd = prev.mpd-discord-rpc.overrideAttrs (_oldAttrs: rec {
    pname = "wpaperd";
    version = "1.1.2-dev";
    src = prev.fetchFromGitHub {
      owner = "danyspin97";
      repo = "wpaperd";
      rev = "3d7e6b0fabea249463d3b6fff5307a111e15bbdc";
      hash = "sha256-YwWJQW809CawlIR/w+xVNxce6g4eQWi/9TG0gORipdE=";
    };
    buildInputs = [
      prev.wayland
      prev.libGL
      prev.libxkbcommon
    ];
    cargoDeps = final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-PZB3Dcd7iCmWZBqEmIrUlNy1Gf95YVEbgd1RPFSdNxU=";
    };
  });
}
