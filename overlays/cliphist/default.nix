final: prev: {
  cliphist = prev.cliphist.overrideAttrs (_old: {
    src = final.fetchFromGitHub {
      owner = "sentriz";
      repo = "cliphist";
      rev = "8c48df70bb3d9d04ae8691513e81293ed296231a";
      sha256 = "sha256-tImRbWjYCdIY8wVMibc5g5/qYZGwgT9pl4pWvY7BDlI=";
    };
    vendorHash = "sha256-gG8v3JFncadfCEUa7iR6Sw8nifFNTciDaeBszOlGntU=";
  });
}
