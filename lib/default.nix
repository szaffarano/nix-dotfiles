inputs: {
  mkHome = import ./home-manager.nix inputs;
  mkDarwin = import ./darwin.nix inputs;
}
