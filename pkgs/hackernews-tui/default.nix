{
  lib,
  rustPlatform,
  pkgs,
}:
rustPlatform.buildRustPackage {
  pname = "hackernews-tui";
  version = "0.14.0-dev";

  src = pkgs.fetchFromGitHub {
    owner = "aome510";
    repo = "hackernews-TUI";
    rev = "2da6a91a30aacbfa09ac40692712986034facf68";
    hash = "sha256-p2MhVM+dbNiWlhvlSKdwXE37dKEaE2JCmT1Ari3b0WI=";
  };

  cargoHash = "sha256-KuqAyuU/LOFwvvfplHqq56Df4Dkr5PkUK1Fgeaq1REs=";

  meta = with lib; {
    description = "hackernews-TUI is a Hacker News client for the terminal";
    homepage = "https://github.com/aome510/hackernews-TUI/";
    license = licenses.mit;
    mainProgram = "hackernews_tui";
    maintainers = [];
  };
}
