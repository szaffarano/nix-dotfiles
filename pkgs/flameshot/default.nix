{pkgs}: (pkgs.flameshot.overrideAttrs (oldAttrs: {
  src = pkgs.fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    rev = "5f30631a415a7202b474fddc68de5b3904cd5d87";
    sha256 = "sha256-tt9Q8HWNIXwmwjY6/8SpJSOCIKJ+P56BYpANykGxfYM=";
  };
  cmakeFlags = [
    "-DUSE_WAYLAND_CLIPBOARD=1"
    "-DUSE_WAYLAND_GRIM=1"
  ];
  buildInputs = oldAttrs.buildInputs ++ [pkgs.libsForQt5.kguiaddons];
}))
