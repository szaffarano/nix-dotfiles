inputs: {
  mkHome = import ./home-manager.nix inputs;
  mkDarwin = import ./darwin.nix inputs;
  unfreePredicate = import ./non-free-config.nix inputs;
}
