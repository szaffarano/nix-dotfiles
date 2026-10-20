{inputs, ...}: {
  additions = final: _:
    import ../pkgs {
      pkgs = final;
      inherit inputs;
    };

  # FIXME: not using nightly until https://github.com/nvim-orgmode/orgmode/issues/1049 is fixed
  # neovim = inputs.neovim-nightly.overlays.default;

  zig = inputs.zig.overlays.default;

  # cliphist = import ./cliphist;

  # intel-graphics-compiler = import ./intel-graphics-compiler;

  nur = inputs.nur.overlays.default;

  pass-secret-service = import ./pass-secret-service;

  # FIXME: Remove once https://github.com/NixOS/nixpkgs/pull/572951 reaches nixos-unstable.
  # Applies the corrected pnpmDeps hash to the pnpm-based build (>= 6.0.2). Guarded so it is a
  # no-op on the yarn-based 5.3.0 currently pinned, which has no pnpmDeps attribute.
  typescript-language-server = _: prev: {
    typescript-language-server =
      if prev.typescript-language-server ? pnpmDeps
      then
        prev.typescript-language-server.overrideAttrs (old: {
          pnpmDeps = old.pnpmDeps.overrideAttrs (_: {
            outputHash = "sha256-xR/EF60lVBsITKgH7wCM2wHM46PFQevD51KfCENSUH4=";
          });
        })
      else prev.typescript-language-server;
  };
  # FIXME: Remove once https://github.com/NixOS/nixpkgs/pull/573028 reaches nixos-unstable.
  # Bumps tmux 3.7c -> 3.8.
  tmux = final: prev: {
    tmux = prev.tmux.overrideAttrs (_: rec {
      version = "3.8";
      src = final.fetchFromGitHub {
        owner = "tmux";
        repo = "tmux";
        tag = version;
        hash = "sha256-pv2wlr3coo+E0pfpb58giJJQn9PGgMFqtVA6nk+9JdE=";
      };
    });
  };

  # FIXME: Remove once https://github.com/NixOS/nixpkgs/pull/576239 reaches nixos-unstable.
  # Bumps tmuxPlugins.tmux-toggle-popup 0.5.1 -> 0.5.2.
  tmux-toggle-popup = final: prev: {
    tmuxPlugins =
      prev.tmuxPlugins
      // {
        tmux-toggle-popup = prev.tmuxPlugins.tmux-toggle-popup.overrideAttrs (_: rec {
          version = "0.5.2";
          src = final.fetchFromGitHub {
            owner = "loichyan";
            repo = "tmux-toggle-popup";
            tag = "v${version}";
            hash = "sha256-HKGtcTILJvrtCvN8H21QtSnKbwQHhhbR3VzINbFGTr4=";
          };
        });
      };
  };

  # wl-clipboard = import ./wl-clipboard;

  # FIXME: Remove once https://github.com/NixOS/nixpkgs/pull/544671 is promoted
  # spotify-player = import ./spotify-player;

  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.stdenv.hostPlatform.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.stdenv.hostPlatform.system}'
  #
  # Thanks Misterio77!
  flake-inputs = final: _: {
    inputs =
      builtins.mapAttrs (
        _: flake: let
          legacyPackages = (flake.legacyPackages or {}).${final.stdenv.hostPlatform.system} or {};
          packages = (flake.packages or {}).${final.stdenv.hostPlatform.system} or {};
        in
          if legacyPackages != {}
          then legacyPackages
          else packages
      )
      inputs;
  };
}
