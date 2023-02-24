{
  description = "Sebas's home-manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    let lib = import ./lib inputs;
    in {
      overlays = [
        inputs.nixgl.overlay
        (import ./overlays/kitty)
        (import ./overlays/chromium)
      ];
      homeModules = import ./modules inputs;

      homeConfigurations = {
        "sebas@ubuntu" = lib.mkHome "sebas" "ubuntu" "x86_64-linux";
      };

      darwinConfigurations = {
        "Sebastians-MacBook-Pro" =
          lib.mkDarwin "szaffarano" "macbook" "aarch64-darwin";
      };
    };
}
