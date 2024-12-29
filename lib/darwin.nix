# TODO: Not tested after the refactoring
{self, ...} @ inputs: user: host: system: let
  currentUser = {
    ${user} = {
      home = "/Users/${user}";
    };
  };

  nixpkgsConfig = {
    inherit system;
    inherit (self) overlays;
    config = {
      modules = [];
      allowUnfree = true;
      # allowUnfreePredicate = import ./non-fkree-config.nix inputs;
    };
  };

  homeManagerModules = import "${self}/modules/home-manager" inputs;
  homeManagerConfig = import "${self}/hosts/${user}@${host}/home.nix" inputs;

  darwinModules = import "${self}/modules/darwin";
  darwinConfig = "${self}/hosts/system@${host}/configuration.nix";
in
  inputs.darwin.lib.darwinSystem {
    inherit system;
    modules =
      [
        darwinConfig
        inputs.home-manager.darwinModules.home-manager
        inputs.nur.nixosModules.nur
        {
          nixpkgs = nixpkgsConfig;
          home-manager = {
            sharedModules = builtins.attrValues homeManagerModules ++ [inputs.nur.nixosModules.nur];
            useGlobalPkgs = true;
            useUserPackages = true;
            users."${user}" = homeManagerConfig;
            verbose = false;
          };
        }
      ]
      ++ builtins.attrValues darwinModules;
    specialArgs = {inherit self inputs currentUser;};
  }
