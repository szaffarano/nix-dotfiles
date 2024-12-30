{
  pkgs,
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.disko.packages.${pkgs.system}) disko;
in {
  default = pkgs.mkShell {
    inherit (outputs.checks.${pkgs.system}.pre-commit-check) shellHook;

    NIX_CONFIG = "extra-experimental-features = nix-command flakes";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

    buildInputs = outputs.checks.${pkgs.system}.pre-commit-check.enabledPackages;

    nativeBuildInputs = with pkgs; [
      age
      cachix
      deadnix
      deploy-rs
      disko
      git
      gnupg
      nix
      nixos-generators
      openssl
      paper-age
      pkg-config
      sops
      ssh-to-age
      statix
    ];
  };

  fhs = let
    libraries = with pkgs; [systemd];
  in
    (pkgs.buildFHSEnv {
      name = "fhs";
      multiPkgs = pkgs: (with pkgs; [
        zlib
        zstd
      ]);
      runScript = "zsh";
      profile = ''
        export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
      '';
    })
    .env;

  pythonDev = pkgs.mkShell {
    CONFIGURE_OPTS = "--with-openssl=${pkgs.openssl.dev}";

    nativeBuildInputs = with pkgs; [
      bzip2
      mise
      expat
      gcc
      libffi
      libxcrypt
      ncurses
      openssl
      readline
      sqlite
      xz
      zlib
    ];
  };
}
