final: prev: {
  ollama = prev.ollama.overrideAttrs (_old: rec {
    version = "0.5.5";
    src = final.fetchFromGitHub {
      owner = "ollama";
      repo = "ollama";
      tag = "v${version}";
      hash = "sha256-tfq4PU+PQWw9MaBQtI/+vr3GR8be9R22c3JyM43RPwA=";
      fetchSubmodules = true;
    };
    vendorHash = "sha256-1uk3Oi0n4Q39DVZe3PnZqqqmlwwoHmEolcRrib0uu4I=";
    postInstall = final.lib.optionalString final.stdenv.hostPlatform.isLinux ''
      # copy libggml_*.so and runners into lib
      # https://github.com/ollama/ollama/blob/v0.4.4/llama/make/gpu.make#L90
      mkdir -p $out/lib
      cp -r dist/*/lib/* $out/lib/
    '';
  });
}
