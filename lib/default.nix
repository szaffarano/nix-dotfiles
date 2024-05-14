inputs: {
  mkHome = import ./home-manager.nix inputs;
  mkNixOS = import ./nixos.nix inputs;
  mkDarwin = import ./darwin.nix inputs;
  toHyprconf = import ./hyprland.nix inputs;
}
