{
  description = "Sebas's home-manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nur.url = "github:nix-community/NUR";

    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs:
    let
      customOverlays = import ./overlays;
      overlays = [ inputs.nixgl.overlay inputs.neovim-nightly-overlay.overlay ]
        ++ builtins.attrValues customOverlays;

      libInputs = inputs // {
        overlays = overlays;
        homeModules = import ./modules/home-manager inputs;
      };

      lib = import ./lib libInputs;
    in
    {
      homeConfigurations = {
        "sebas@ubuntu" = lib.mkHome "sebas" "ubuntu" "x86_64-linux";
        "sebas@archlinux" = lib.mkHome "sebas" "archlinux" "x86_64-linux";
        "szaffarano@work" = lib.mkHome "szaffarano" "work" "x86_64-linux";
      };

      darwinConfigurations = {
        "szaffarano@macbook" =
          lib.mkDarwin "szaffarano" "macbook" "aarch64-darwin";
      };
    };
}
