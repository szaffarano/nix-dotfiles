{ self, nixpkgs, ... }@inputs:
config:
let
  configFile = "${self}/users/${config.user.name}/${config.host.name}.nix";
  outputs = self.outputs // {
    inherit (config) user;
  };
in
inputs.home-manager.lib.homeManagerConfiguration {
  modules = [
    configFile
    inputs.nix-colors.homeManagerModule
    inputs.nix-index-database.hmModules.nix-index
    inputs.nixvim.homeManagerModules.nixvim
    inputs.nur.nixosModules.nur
    "${self}/modules/home-manager"
  ];

  pkgs = import inputs.nixpkgs { system = config.host.arch; };

  extraSpecialArgs = {
    inherit inputs outputs;
  };
}
