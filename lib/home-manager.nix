{ self, ... }@inputs:
user: host: system:
let
  configFile = import "${self}/hosts/${user}@${host}/home.nix" inputs;
  homeDirectory = "/home/${user}";

in
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfreePredicate = (import ./non-free-config.nix inputs);
      permittedInsecurePackages = [ ];
    };
    overlays = inputs.overlays;
  };

  modules = builtins.attrValues inputs.homeModules ++ [
    configFile
    inputs.nur.nixosModules.nur
    {
      home = {
        username = user;
        homeDirectory = homeDirectory;
        stateVersion = "22.11";
      };
    }
  ];
}
