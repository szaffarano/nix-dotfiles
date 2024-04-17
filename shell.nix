{ pkgs, inputs, ... }:
let
  disko = inputs.disko.packages.${pkgs.system}.disko;
in
{
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
    nativeBuildInputs = with pkgs; [
      age
      disko
      git
      gnupg
      home-manager
      nix
      sops
      ssh-to-age
    ];
  };

  fhs =
    let
      libraries = with pkgs; [ systemd ];
    in
    (pkgs.buildFHSEnv {
      name = "fhs";
      multiPkgs =
        pkgs:
        (with pkgs; [
          zlib
          zstd
        ]);
      runScript = "zsh";
      profile = ''
        export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
      '';
    }).env;

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
