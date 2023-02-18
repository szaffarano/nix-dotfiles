{
  description = "Sebas's home-manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl.url = "github:guibou/nixGL";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixgl, home-manager, nix-index-database, ... }:
    let
      mkPkgs = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ nixgl.overlay ];
        };
      hmConfig = user: host: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs system;

          modules = [
            (./hosts + "/${user}@${host}" + /home.nix)
            {
              home = {
                homeDirectory = "/home/${user}";
                username = user;
                stateVersion = "22.11";
              };
            }
          ];
        };
    in {
      homeConfigurations."sebas@ubuntu" =
        hmConfig "sebas" "ubuntu" "x86_64-linux";
      packages.x86_64-linux."sebas@ubuntu" =
        self.homeConfigurations."sebas@ubuntu".activationPackage;
    };
}
