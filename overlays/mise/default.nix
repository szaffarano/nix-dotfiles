# https://github.com/danyspin97/wpaperd/issues/79
_final: prev: {
  mise = prev.mise.overrideAttrs (old: rec {
    version = "2025.1.8";

    src = prev.fetchFromGitHub {
      owner = "jdx";
      repo = "mise";
      rev = "v${version}";
      hash = "sha256-+Eqn5e3Ci8djcdDSr5lDHpta+mBgBx/rAPkkro0QBlA=";
    };

    cargoDeps = old.cargoDeps.overrideAttrs (
      prev.lib.const {
        inherit src;
        outputHash = "sha256-kkuIEgauO8urEhg6H4dO7ByUAbWEEf1ChcuumLOtMjk=";
      }
    );
  });
}
