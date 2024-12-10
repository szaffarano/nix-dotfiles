{ self, nixpkgs, ... }@inputs:
config:
let
  configFile = "${self}/users/${config.user.name}/${config.host.name}.nix";
  outputs = self.outputs // { };
in
inputs.home-manager.lib.homeManagerConfiguration {
  modules = [
    configFile
    inputs.nix-index-database.hmModules.nix-index
    inputs.nixvim.homeManagerModules.nixvim
    "${self}/modules/home-manager"
  ];

  pkgs = import inputs.nixpkgs { system = config.host.arch; };

  extraSpecialArgs = {
    inherit inputs outputs;
  };
}
