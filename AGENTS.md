# AGENTS.md

This file provides guidance for agentic coding agents working with this NixOS
dotfiles repository.

## Repository Overview

This is a NixOS-based dotfiles repository using flakes for declarative system
and home-manager configurations. The repository manages multiple machines and
users with encrypted secrets using SOPS.

## Project Structure

- `system/` — System configuration, including infra setups.
- `modules/nixos/` — NixOS modules for system configurations.
- `modules/home-manager/` — Home Manager modules for user configurations.
- `overlays` — Nixpkgs overlays for custom package definitions.
- `pkgs/` — Package definitions for NixOS and Home Manager.
- `users/` — User-specific configurations, including Home Manager setups.

### Key Components

- **Flake inputs**: Manages dependencies like nixpkgs, home-manager, sops-nix,
  disko
- **System configurations**: NixOS setups for bock, weisse, zaffarano-elastic,
  pilsen, lambic (RPi)
- **Home configurations**: User environments with desktop/development tools
- **SOPS integration**: Encrypted secrets management with age keys
- **Disko**: Declarative disk partitioning and formatting
- **Pre-commit hooks**: Automated formatting and linting (deadnix, alejandra,
  ruff, etc.)

### Machine Types

- Desktop/laptop systems (bock, weisse, pilsen, zaffarano-elastic)
- Raspberry Pi system (lambic) with ARM64 support
- Development shells for various environments

## Build/Lint/Test Commands

- `nix fmt` — Format all files using treefmt (alejandra for Nix, ruff for
  Python, shfmt for shell)
- `nix flake check` — Run all checks including pre-commit hooks (deadnix,
  statix, ruff, pyright, etc.)
- `nix develop` — Enter development shell with all tools
- `nix build '.#nixosConfigurations.<hostname>.config.system.build.toplevel'` —
  Build system configuration
- `sudo nixos-rebuild switch --flake .#<hostname>` — Apply system configuration
- `home-manager switch --flake .` — Apply home-manager configuration.

## Code Style Guidelines

### Nix Files

- Use alejandra formatter (2-space indentation)
- Remove dead code with deadnix
- Follow existing module structure: `{ imports = [ ./submodules ]; }`
- Use `lib.mkIf`, `lib.mkDefault`, `lib.mkForce` for conditionals
- Prefer `with pkgs;` sparingly, explicit `pkgs.package` is better

### Python Files

- Use ruff for formatting and linting
- Type hints required (pyright checking enabled)
- Follow PEP 8 conventions

### Shell Scripts

- Use `#!/usr/bin/env bash` shebang
- Include `set -euo pipefail` for safety
- Format with shfmt (2-space indentation)

### Secret Management Workflow

1. Generate SSH keys for new machines
1. Convert to age format with ssh-to-age
1. Update `.sops.yaml` with new recipients
1. Create/edit secrets files with `sops`
1. Reference secrets in system configurations

When working with this repository, always use the flake-based commands and
respect the existing directory structure. System changes require sudo
privileges, while home-manager changes run as the user.
