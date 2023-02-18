{
  description = "Sebas's home-manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl.url = "github:guibou/nixGL";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    let lib = import ./lib inputs;
    in {
      overlays = [ inputs.nixgl.overlay ];
      homeModules = import ./modules inputs;

      homeConfigurations = {
        "sebas@ubuntu" = lib.mkHome "sebas" "ubuntu" "x86_64-linux";
      };
    };
}
