{ self, nixpkgs, ... }@inputs:
config:
let
  outputs = self.outputs // config;
  configFile = "${self}/users/${config.user.name}/${config.host.name}.nix";
in
nixpkgs.lib.nixosSystem {
  modules = [
    inputs.nix-index-database.nixosModules.nix-index
    inputs.home-manager.nixosModules.home-manager

    "${self}/modules/nixos"
    "${self}/system/${config.host.name}"
    {
      home-manager = {
        useGlobalPkgs = false;
        useUserPackages = true;
        users.${config.user.name} = {
          imports = [
            inputs.nix-colors.homeManagerModule
            inputs.nix-index-database.hmModules.nix-index
            inputs.nur.nixosModules.nur
            "${self}/modules/home-manager"

            configFile
          ];
        };
      };
    }
  ];
  specialArgs = {
    inherit inputs outputs;
  };
}
