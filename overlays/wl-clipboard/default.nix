final: prev: {
  wl-clipboard = prev.wl-clipboard.overrideAttrs (old: {
    patches =
      old.patches
      or []
      ++ [
        # see https://github.com/bugaevc/wl-clipboard/issues/177
        ./wl-copy.patch
        (final.fetchpatch {
          url = "https://github.com/bugaevc/wl-clipboard/pull/204.patch";
          hash = "sha256-6rljcv5yXzQeCUO6IoP1irM0qUEVgmQ+UA6vcJOYeFs=";
        })
      ];
  });
}
