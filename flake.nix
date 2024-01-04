{
  description = "Sebas's home-manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";

    nix-colors.url = "github:misterio77/nix-colors";

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;

      localLib = import ./lib inputs;
      lib = nixpkgs.lib // home-manager.lib // localLib;
      systems = [ "x86_64-linux" ];
      forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
      pkgsFor = nixpkgs.legacyPackages;
    in
    {
      inherit lib;

      user = {
        name = "sebas";
        fullName = "Sebastian Zaffarano";
        email = "sebas@zaffarano.com.ar";
        gpgKey = "0x14F35C58A2191587";
      };

      disko = inputs.disko;

      nixosModules = import ./modules/nixos { inherit inputs; };
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit inputs outputs; };


      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      devShells =
        forEachSystem (pkgs: import ./shell.nix { inherit pkgs inputs; });

      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      homeConfigurations = {
        "sebas@pilsen" = lib.mkHome "sebas" "pilsen" "x86_64-linux";
        # "sebas@archlinux" = lib.mkHome "sebas" "archlinux" "x86_64-linux";
        # "szaffarano@work" = lib.mkHome "szaffarano" "work" "x86_64-linux";
      };

      darwinConfigurations = {
        "szaffarano@macbook" =
          lib.mkDarwin "szaffarano" "macbook" "aarch64-darwin";
      };
    };
}
