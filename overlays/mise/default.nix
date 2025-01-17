# https://github.com/danyspin97/wpaperd/issues/79
_final: prev: {
  mise = prev.mise.overrideAttrs (old: rec {
    version = "2025.1.6";

    src = prev.fetchFromGitHub {
      owner = "jdx";
      repo = "mise";
      rev = "v${version}";
      hash = "sha256-eMKrRrthV37ndsF47jjNxigsJ5WDsCDCit9J88l5dHE=";
    };

    cargoDeps = old.cargoDeps.overrideAttrs (
      prev.lib.const {
        inherit src;
        outputHash = "sha256-2bpceXsJtez01Gts9jqrv42kWx9t1tZ2qvzpnpWLC0U=";
      }
    );
  });
}
