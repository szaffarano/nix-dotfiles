{ self, nixpkgs, ... }@inputs:
config:
let
  outputs = self.outputs // config;
in
nixpkgs.lib.nixosSystem {
  modules = [
    "${self}/modules/nixos"
    "${self}/system/${config.host.name}"
    inputs.nix-index-database.nixosModules.nix-index
  ];
  specialArgs = { inherit inputs outputs; };
}
