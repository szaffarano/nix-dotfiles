_final: prev: {
  librespot = prev.librespot.overrideAttrs (old: {
    patches =
      old.patches
      or []
      ++ [
        ../spotify-player/1524.patch
        ../spotify-player/1527.patch
      ];
  });
}
