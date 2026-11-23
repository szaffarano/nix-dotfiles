_final: prev: {
  fishPlugins =
    prev.fishPlugins
    // {
      forgit = prev.fishPlugins.forgit.overrideAttrs (_: {
        version = "26.10.0";
        src = prev.fetchFromGitHub {
          owner = "wfxr";
          repo = "forgit";
          tag = "26.10.0";
          hash = "sha256-Kno14XqXwtG0zWVjrikoXf7eIXo3pj7YbSoQOYUcAI4=";
        };
      });
    };
}
