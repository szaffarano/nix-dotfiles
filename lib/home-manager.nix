{ self, nixpkgs, ... }@inputs:
user: host: system:
let
  configFile = ../users/${user}/${host}.nix;
  outputs = self.outputs;
in
inputs.home-manager.lib.homeManagerConfiguration {
  modules = builtins.attrValues outputs.homeManagerModules ++ [
    configFile
    inputs.nix-colors.homeManagerModule
    inputs.nix-index-database.hmModules.nix-index
    inputs.nixvim.homeManagerModules.nixvim
    inputs.nur.nixosModules.nur
  ];

  pkgs = import inputs.nixpkgs {
    inherit system;
  };

  extraSpecialArgs = { inherit inputs outputs; };
}
