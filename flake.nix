{
  description = "Home Manager configuration of Sebas";

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

  outputs = { nixpkgs, home-manager, nix-index-database, nixgl, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixgl.overlay ];
        config = { allowUnfree = true; };
      };
    in {
      homeConfigurations.sebas = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [ nix-index-database.hmModules.nix-index ./home ];
      };
    };
}
