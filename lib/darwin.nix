{ self, ... }@inputs:
user: host: system:
let
  currentUser = { szaffarano = { home = "/Users/${user}"; }; };

  nixpkgsConfig = {
    inherit system;
    overlays = self.overlays;
    config = {
      modules = [ inputs.nur.nixosModules.nur ];
      allowUnfreePredicate = pkg:
        builtins.elem (inputs.nixpkgs.lib.getName pkg) [
          "dropbox"
          "grammarly"
          "lastpass-password-manager"
          "skypeforlinux"
          "slack"
          "zoom"
        ];

    };
  };

  extraModules = import ../modules inputs;
  config-file = import "${self}/hosts/${user}@${host}/home.nix" inputs;

in
inputs.darwin.lib.darwinSystem {
  inherit system;
  modules = [
    "${self}/configuration.nix"
    inputs.home-manager.darwinModules.home-manager
    inputs.nur.nixosModules.nur
    {
      nixpkgs = nixpkgsConfig;
      home-manager.sharedModules = builtins.attrValues extraModules
        ++ [ inputs.nur.nixosModules.nur ];
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${user}" = config-file;
      home-manager.verbose = false;
    }
  ];
  specialArgs = { inherit self inputs currentUser; };
}
