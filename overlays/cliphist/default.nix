final: prev: {
  cliphist = prev.cliphist.overrideAttrs (_old: {
    src = final.fetchFromGitHub {
      owner = "sentriz";
      repo = "cliphist";
      rev = "1350191061a7df1f70cd6e652eb0517d3a9a590f";
      sha256 = "sha256-lM8xIQHF/Vq4VvcSXURhZUkvF2b6ptwHyR4mNOpvFuQ=";
    };
    vendorHash = "sha256-No8d9ztepBO+fgF2XkEf/tyCPDAD57rBkzA8iVyNUmw=";
  });
}
