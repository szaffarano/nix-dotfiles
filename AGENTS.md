# AGENTS.md

This file provides guidance for agentic coding agents working with this NixOS
dotfiles repository.

## Repository Overview

This is a NixOS-based dotfiles repository using flakes for declarative system
and home-manager configurations. The repository manages multiple machines and
users with encrypted secrets using SOPS.

## Project Architecture

### Directory Structure

```text
.
├── flake.nix              # Main flake - inputs, outputs, configurations
├── lib/                   # Local library helpers
│   ├── default.nix        # Library exports (mkHome, mkNixOS, toHyprconf)
│   ├── home-manager.nix   # Home-manager configuration builder
│   ├── nixos.nix          # NixOS system builder
│   └── hyprland.nix       # Hyprland config utilities
├── modules/
│   ├── nixos/             # NixOS modules (system-wide)
│   │   ├── default.nix    # Aggregates all NixOS modules
│   │   ├── desktop/       # Desktop environment (Hyprland, Sway, XDG)
│   │   ├── features/      # Optional features via feature flag system
│   │   ├── global/        # Global system settings (audio, locale, ssh)
│   │   ├── options.nix    # Custom NixOS options (nixos.custom.*)
│   │   └── users/         # User account definitions
│   └── home-manager/      # Home Manager modules (per-user)
│       ├── default.nix    # Aggregates all home-manager modules
│       ├── bootstrap/     # Bootstrap configurations
│       ├── desktop/       # Desktop apps and theming
│       ├── develop/       # Development tools
│       ├── fonts/         # Font configurations
│       ├── sound/         # Audio settings
│       ├── terminal/      # Shell, editors, CLI tools
│       └── options.nix    # Custom home-manager options (home.custom.*)
├── overlays/              # Nixpkgs overlays
│   └── default.nix        # Overlay definitions
├── pkgs/                  # Custom package definitions
│   └── default.nix        # Package exports
├── system/                # Machine-specific NixOS configurations
│   ├── bock/              # VM/server configuration
│   ├── weisse/            # Laptop configuration
│   ├── pilsen/            # Desktop configuration
│   └── zaffarano-elastic/ # Work machine configuration
├── users/                 # Per-user, per-machine home-manager configs
│   └── sebas/             # User 'sebas' configurations
│       ├── bock.nix
│       ├── weisse.nix
│       ├── pilsen.nix
│       └── zaffarano-elastic.nix
├── treefmt.nix            # treefmt configuration
├── shell.nix              # Development shells
└── .sops.yaml             # SOPS secrets configuration
```

### Flake Structure

The `flake.nix` defines:

**Inputs** (key dependencies):

- `nixpkgs`: Main nixpkgs channel (nixos-unstable)
- `home-manager`: User environment management
- `sops-nix`: Secret management
- `disko`: Declarative disk partitioning
- `hardware`: NixOS hardware configurations
- Plus various tool-specific flakes (hyprland, neovim, rust, zig, etc.)

**Outputs**:

- `nixosConfigurations`: 4 machines (bock, weisse, pilsen, zaffarano-elastic)
- `packages`: Custom packages per system
- `overlays`: Nixpkgs modifications
- `devShells`: Development environments
- `checks`: Pre-commit hooks

### Key Patterns

#### 1. Feature Flag System

Both NixOS and home-manager use a custom feature flag system:

**NixOS** (`modules/nixos/options.nix`):

```nix
nixos.custom.features = {
  register = "";  # Newline-separated list of available features
  enable = [];    # List of features to enable
};
```

**Usage in system config** (`system/bock/default.nix`):

```nix
nixos.custom.features.enable = [
  "home-manager"
  "nix-ld"
  "quietboot"
  "sensible"
];
```

**Feature modules** (`modules/nixos/features/sway.nix`):

```nix
{ config, lib, ... }:
let
  feature_name = "sway";
  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in {
  config = {
    programs.sway = lib.mkIf enabled { enable = true; };
    nixos.custom.features.register = feature_name;
  };
}
```

#### 2. Machine Configuration Pattern

Each machine has a directory under `system/<hostname>/`:

```nix
# system/bock/default.nix
{ inputs, flakeRoot, ... }:
let
  userName = "sebas";
  hostName = "bock";
  sebas = import "${flakeRoot}/modules/nixos/users/sebas.nix" {
    inherit userName hostName;
  };
in {
  imports = [
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    "${flakeRoot}/modules/nixos"
    sebas
  ];

  nixos.custom.features.enable = [ "home-manager" "nix-ld" /* ... */ ];
  networking.hostName = hostName;

  sops.secrets.sebas-password = {
    sopsFile = ./secrets.yaml;
    neededForUsers = true;
  };
}
```

#### 3. User Configuration Pattern

Users are defined in `modules/nixos/users/<username>.nix`:

```nix
{ hostName, userName ? "sebas", ... }:
{ config, lib, flakeRoot, pkgs, ... }:
let
  # Fetch SSH keys from GitHub
  keys = pkgs.fetchurl {
    url = "https://github.com/szaffarano.keys";
    hash = "sha256-...";
  };
in {
  users.users.${userName} = {
    hashedPasswordFile = config.sops.secrets."${userName}-password".path;
    isNormalUser = true;
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile keys);
  };

  home-manager.users.${userName} = {
    imports = [
      "${flakeRoot}/modules/home-manager"
      "${flakeRoot}/users/${userName}/${hostName}.nix"
    ];
  };
}
```

#### 4. Per-Machine User Config

Users have per-machine configs in `users/<username>/<hostname>.nix`:

```nix
# users/sebas/bock.nix
{ pkgs, ... }: {
  home.custom.features.enable = [];
  home.packages = [ pkgs.gcc ];

  terminal.zsh = {
    enable = true;
    extras = [ "local" ];
  };
}
```

#### 5. Disko Disk Configuration

Machines use disko for declarative partitioning:

```nix
# system/bock/disk-config.nix
{ disks ? [ "/dev/vda" ], ... }: {
  disk.disk-1 = {
    type = "disk";
    device = builtins.elemAt disks 0;
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "nixos";
            content = {
              type = "btrfs";
              subvolumes = {
                "/root" = { mountpoint = "/"; };
                "/home" = { mountpoint = "/home"; };
              };
            };
          };
        };
      };
    };
  };
}
```

#### 6. Custom Options Pattern

**NixOS** (`modules/nixos/options.nix`):

```nix
{ config, lib, ... }: {
  options.nixos.custom = with lib; {
    debug = mkEnableOption "debug NixOS";
    power.wol.phyname = mkOption { type = types.str; default = null; };
    features = { /* feature flag options */ };
  };
}
```

**Home-manager** (`modules/home-manager/options.nix`):

```nix
{ lib, config, ... }: {
  options.home.custom = with lib; {
    debug = mkEnableOption "debug home-manager";
    allowed-unfree-packages = mkOption { type = listOf package; default = []; };
    permitted-insecure-packages = mkOption { type = listOf str; default = []; };
    features = { /* feature flag options */ };
  };
}
```

#### 7. Module Aggregation Pattern

Modules aggregate submodules via imports:

```nix
# modules/nixos/default.nix
{
  imports = [
    ./desktop
    ./features
    ./global
    ./options.nix
  ];
}
```

```nix
# modules/nixos/features/default.nix
{
  imports = [
    ./calibre.nix
    ./desktop.nix
    ./home-manager.nix
    ./hyprland.nix
    ./sway.nix
    # ... etc
  ];
}
```

#### 8. Package Definition Pattern

Custom packages in `pkgs/default.nix`:

```nix
{ pkgs, inputs, ... }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = {
    my-package = callPackage ./my-package {};
    # ...
  };
in packages
```

#### 9. Overlay Pattern

Overlays in `overlays/default.nix`:

```nix
{ inputs, ... }: {
  # Add custom packages to pkgs
  additions = final: _: import ../pkgs { pkgs = final; inherit inputs; };

  # Use upstream overlays
  zig = inputs.zig.overlays.default;
  nur = inputs.nur.overlays.default;

  # Expose flake inputs as pkgs.inputs.<name>
  flake-inputs = final: _: { inputs = /* ... */; };
}
```

#### 10. Secrets Management (SOPS)

Configuration in `.sops.yaml`:

```yaml
keys:
  - users:
      - &sebas_pgp <key-id>
  - hosts:
      - &bock age1...
      - &weisse age1...

creation_rules:
  - path_regex: system/bock/secrets.yaml
    key_groups:
      - age:
          - *bock
        pgp:
          - *sebas_pgp
```

Usage in machine config:

```nix
sops.secrets.sebas-password = {
  sopsFile = ./secrets.yaml;
  neededForUsers = true;
};
```

## Build/Lint/Test Commands

```bash
# Format all files using treefmt (alejandra for Nix, ruff for Python, shfmt for shell)
nix fmt

# Run all checks including pre-commit hooks (deadnix, statix, ruff, pyright, etc.)
nix flake check

# Enter development shell with all tools
nix develop

# Build system configuration
nix build '.#nixosConfigurations.<hostname>.config.system.build.toplevel'

# Apply system configuration
sudo nixos-rebuild switch --flake .#<hostname>

# Apply home-manager configuration
home-manager switch --flake .

# Build Raspberry Pi SD image
nix build '.#nixosConfigurations.<hostname>.config.system.build.sdImage'
```

## Code Style Guidelines

### Nix Files

- **Formatter**: alejandra (2-space indentation)
- **Dead code removal**: deadnix
- **Linting**: statix
- **Module structure**:

  ```nix
  { pkgs, lib, config, ... }: {
    imports = [ /* submodules */ ];
    options = { /* custom options */ };
    config = { /* configuration */ };
  }
  ```

- Use `lib.mkIf`, `lib.mkDefault`, `lib.mkForce` for conditionals
- Prefer explicit `pkgs.package` over `with pkgs;`
- Function arguments: use `...` for unused parameters

### Python Files

- Use ruff for formatting and linting
- Type hints required (pyright checking enabled)
- Follow PEP 8 conventions

### Shell Scripts

- Use `#!/usr/bin/env bash` shebang
- Include `set -euo pipefail` for safety
- Format with shfmt (2-space indentation)

### Pre-commit Hooks Enabled

- `alejandra`: Nix formatting
- `deadnix`: Remove dead Nix code
- `detect-private-keys`: Security check
- `end-of-file-fixer`: Ensure trailing newline
- `mixed-line-endings`: Consistent line endings
- `pyright`: Python type checking
- `ruff`: Python linting
- `ruff-format`: Python formatting
- `rumdl`: Markdown linting
- `shfmt`: Shell script formatting
- `statix`: Nix linting
- `stylua`: Lua formatting
- `taplo`: TOML formatting
- `trim-trailing-whitespace`: Clean whitespace

## Machine Types

- **bock**: VM/server (x86_64-linux)
- **weisse**: Laptop with desktop environment
- **pilsen**: Desktop workstation
- **zaffarano-elastic**: Work machine
- **lambic**: Raspberry Pi (ARM64) - mentioned in README, may be in separate branch

## Common Tasks

### Adding a New Machine

1. Generate SSH host keys for the machine
2. Convert to age format: `ssh-to-age -i ssh_host_ed25519_key.pub`
3. Add age recipient to `.sops.yaml`
4. Create `system/<hostname>/default.nix`
5. Create `system/<hostname>/hardware-configuration.nix`
6. Create `system/<hostname>/disk-config.nix` (Disko)
7. Create `system/<hostname>/secrets.yaml` with `sops`
8. Add machine to `flake.nix` outputs.nixosConfigurations
9. Create `users/<username>/<hostname>.nix`

### Adding a New Feature

1. Create feature module in `modules/nixos/features/<feature>.nix`
2. Add to `modules/nixos/features/default.nix` imports
3. Use pattern:

   ```nix
   let
     feature_name = "my-feature";
     enabled = builtins.elem feature_name config.nixos.custom.features.enable;
   in {
     config = {
       # Actual config with lib.mkIf enabled
       nixos.custom.features.register = feature_name;
     };
   }
   ```

### Adding a Custom Package

1. Create `pkgs/<package-name>/default.nix`
2. Add to `pkgs/default.nix` packages set
3. Reference as `pkgs.<package-name>` in configs

### Managing Secrets

1. Edit secrets: `sops system/<hostname>/secrets.yaml`
2. Reference in config:

   ```nix
   sops.secrets.<secret-name> = {
     sopsFile = ./secrets.yaml;
     neededForUsers = true;  # If needed during user creation
   };
   ```

3. Access as `config.sops.secrets.<secret-name>.path`

### Secret Management Workflow

1. Generate SSH keys for new machines
2. Convert to age format with ssh-to-age
3. Update `.sops.yaml` with new recipients
4. Create/edit secrets files with `sops`
5. Reference secrets in system configurations

## Important Notes

- **Always use flake-based commands**: `nix develop`, `nix fmt`, `nix flake check`
- **System changes require sudo**: `sudo nixos-rebuild switch --flake .#<hostname>`
- **Home-manager changes run as user**: `home-manager switch --flake .`
- **Secrets are per-machine**: Each machine has its own `secrets.yaml`
- **LUKS encryption**: Most machines use LUKS + BTRFS subvolumes
- **Feature flags**: Use the custom feature system for optional components
- **Home-manager integration**: Applied via NixOS module, not standalone
- **Cachix caches**: Configured for hyprland, nix-community, and szaffarano

When working with this repository, always use the flake-based commands and
respect the existing directory structure. System changes require sudo
privileges, while home-manager changes run as the user.
