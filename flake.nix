{
  description = "Sebas's home-manager configurations";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://szaffarano.cachix.org"
    ];

    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "szaffarano.cachix.org-1:T4qYO8SxoCddCRetQDQFUDc+tuBZyL7HuGcisMj4wiM="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-bazel-5_1_1.url = "github:nixos/nixpkgs/9cbcd62ada85e015e8117bd7e901bf40b6c767bc";
    # nixpkgs-kernel.url = "github:nixos/nixpkgs/33d1e753c82ffc557b4a585c77de43d4c922ebb5";

    hardware.url = "github:nixos/nixos-hardware";

    wofi-tools = {
      url = "github:szaffarano/wofi-power-menu";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # themes
    base16.url = "github:SenchoPens/base16.nix";
    base16-zathura = {
      url = "github:haozeke/base16-zathura";
      flake = false;
    };
    base16-vim = {
      url = "github:tinted-theming/base16-vim";
      flake = false;
    };
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      systems = [ "x86_64-linux" ];

      inherit (self) outputs;
      inherit (nixpkgs) lib;

      localLib = import ./lib inputs;

      flakeRoot = self;
      specialArgs = {
        inherit
          inputs
          outputs
          localLib
          flakeRoot
          ;
      };

      forEachSystem = f: lib.genAttrs systems (sys: f nixpkgs.legacyPackages.${sys});
    in
    {
      overlays = import ./overlays { inherit inputs outputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs inputs; });

      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = {
        # pilsen = lib.mkNixOS pilsen;
        # bock = lib.mkNixOS bock;
        weisse = nixpkgs.lib.nixosSystem {
          modules = [ "${self}/system/weisse" ];
          inherit specialArgs;
        };

        zaffarano-elastic = nixpkgs.lib.nixosSystem {
          modules = [ "${self}/system/zaffarano-elastic" ];
          inherit specialArgs;
        };

        pilsen = nixpkgs.lib.nixosSystem {
          modules = [ "${self}/system/pilsen" ];
          inherit specialArgs;
        };
      };

      darwinConfigurations = {
        "szaffarano@macbook" = lib.mkDarwin "szaffarano" "macbook" "aarch64-darwin";
      };
    };
}
