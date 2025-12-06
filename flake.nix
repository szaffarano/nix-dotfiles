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
    nixpkgs-bazel-5_1_1.url = "github:nixos/nixpkgs/20075955deac2583bb12f07151c2df830ef346b4";

    hardware.url = "github:nixos/nixos-hardware";

    wofi-tools = {
      url = "github:szaffarano/wofi-power-menu";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    org-mcp-server = {
      url = "github:szaffarano/org-mcp-server";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    rofi-tools = {
      url = "github:szaffarano/rofi-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    temporis = {
      url = "github:reciperium/temporis";
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

    sops-nix.url = "github:Mic92/sops-nix";

    nix-colors.url = "github:misterio77/nix-colors";

    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcp-hub = {
      url = "github:ravitemer/mcp-hub";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-nightly = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-mcp = {
      url = "github:linw1995/nvim-mcp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    treefmt-nix,
    ...
  } @ inputs: let
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

    forEachSystem = f:
      lib.genAttrs systems (
        system:
          f (
            import nixpkgs {
              inherit system;
              config.permittedInsecurePackages = [
                "python-2.7.18.12" # needed by bazel 5.1.1
              ];
            }
          )
      );

    treefmtEval = forEachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in {
    overlays = import ./overlays {inherit inputs outputs;};

    packages = forEachSystem (pkgs: import ./pkgs {inherit pkgs inputs;});

    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs inputs outputs;});

    formatter = forEachSystem (pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);

    nixosConfigurations = {
      bock = nixpkgs.lib.nixosSystem {
        modules = ["${self}/system/bock"];
        inherit specialArgs;
      };

      weisse = nixpkgs.lib.nixosSystem {
        modules = ["${self}/system/weisse"];
        inherit specialArgs;
      };

      zaffarano-elastic = nixpkgs.lib.nixosSystem {
        modules = ["${self}/system/zaffarano-elastic"];
        inherit specialArgs;
      };

      pilsen = nixpkgs.lib.nixosSystem {
        modules = ["${self}/system/pilsen"];
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

    deploy.nodes.lambic = {
      hostname = "lambic";
      profiles.system = {
        sshUser = "sebas";
        user = "root";
        interactiveSudo = true;
        path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.lambic;
      };
    };

    checks = forEachSystem (pkgs: {
      pre-commit-check = inputs.pre-commit-hooks.lib.${pkgs.stdenv.hostPlatform.system}.run {
        src = self;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          detect-private-keys.enable = true;
          end-of-file-fixer.enable = true;
          mixed-line-endings.enable = true;
          pyright.enable = true;
          ruff.enable = true;
          ruff-format.enable = true;
          rumdl.enable = true;
          shfmt.enable = true;
          statix.enable = true;
          stylua.enable = true;
          taplo.enable = true;
          trim-trailing-whitespace.enable = true;
        };
      };
    });
  };
}
