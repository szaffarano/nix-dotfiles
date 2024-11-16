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
      "szaffarano.cachix.org-1:T4qYO8SxoCddCRetQDQFUDc+tuBZyL7HuGcisMj4wiM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-bazel-5_1_1.url = "github:nixos/nixpkgs/9cbcd62ada85e015e8117bd7e901bf40b6c767bc";

    hardware.url = "github:nixos/nixos-hardware";

    wofi-tools = {
      url = "github:szaffarano/wofi-power-menu";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    zig.url = "github:mitchellh/zig-overlay";

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

    nix-colors.url = "github:misterio77/nix-colors";

    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

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

      forEachSystem =
        f:
        lib.genAttrs systems (
          system:
          f (
            import nixpkgs {
              inherit system;
              config.permittedInsecurePackages = [
                "python-2.7.18.8" # needed by bazel 5.1.1
              ];
            }
          )
        );
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

        lambic = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          inherit specialArgs;
          modules = [
            inputs.raspberry-pi-nix.nixosModules.raspberry-pi
            inputs.raspberry-pi-nix.nixosModules.sd-image
            "${self}/system/lambic"
          ];
        };
      };

      darwinConfigurations = {
        "szaffarano@macbook" = lib.mkDarwin "szaffarano" "macbook" "aarch64-darwin";
      };
    };
}
