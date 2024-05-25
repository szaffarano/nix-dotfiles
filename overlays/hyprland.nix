final: prev: {
  hyprland = prev.hyprland.overrideAttrs (oa: {
    src = final.fetchFromGitHub {
      owner = "hyprwm";
      repo = oa.pname;
      fetchSubmodules = true;
      rev = "2ff95bba3fec58b9f1a127fe72dda84b1420a7af";
      hash = "sha256-us5qr9hCqlKu76Sn6oNfxWUn2QgBy2Mejs7JbCmHIHM=";
    };
  });
}
