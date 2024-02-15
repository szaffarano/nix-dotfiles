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

    sops-nix = {
      url = "github:Mic92/sops-nix";
    };

    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
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
      sebas_at_home = {
        name = "sebas";
        fullName = "Sebastian Zaffarano";
        email = "sebas@zaffarano.com.ar";
        gpgKey = "0x14F35C58A2191587";
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGM8VrSbHicyD5mOAivseLz0khnvj4sDqkfnFyipqXCg cardno:19_255_309"
        ];
      };
      szaffarano_at_elastic = {
        name = "szaffarano";
        fullName = "Sebastián Zaffarano";
        email = "sebastian.zaffarano@elastic.co";
        gpgKey = "0xB31A0D3EFDC15D4B";
        authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGM8VrSbHicyD5mOAivseLz0khnvj4sDqkfnFyipqXCg cardno:19_255_309"
        ];
      };
      bock_host = {
        name = "bock";
        arch = "x86_64-linux";
      };
      pilsen_host = {
        name = "pilsen";
        arch = "x86_64-linux";
      };
      zaffarano_host = {
        name = "zaffarano";
        arch = "x86_64-linux";
      };
      bock = {
        user = sebas_at_home;
        host = bock_host;
      };
      pilsen = {
        user = sebas_at_home;
        host = pilsen_host;
      };
      zaffarano = {
        user = szaffarano_at_elastic;
        host = zaffarano_host;
      };

    in
    {
      inherit lib;

      disko = inputs.disko;

      overlays = import ./overlays { inherit inputs outputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      devShells =
        forEachSystem (pkgs: import ./shell.nix { inherit pkgs inputs; });

      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = {
        pilsen = lib.mkNixOS pilsen;
        bock = lib.mkNixOS bock;
        zaffarano = lib.mkNixOS zaffarano;
      };

      homeConfigurations = {
        "sebas@pilsen" = lib.mkHome pilsen;
        "sebas@bock" = lib.mkHome bock;
        "szaffarano@elastic" = lib.mkHome zaffarano;
      };

      darwinConfigurations = {
        "szaffarano@macbook" =
          lib.mkDarwin "szaffarano" "macbook" "aarch64-darwin";
      };
    };
}
