inputs: {
  mkHome = import ./home-manager.nix inputs;
  mkNixOS = import ./nixos.nix inputs;
  toHyprconf = import ./hyprland.nix inputs;
}
