{ inputs, ... }:
{

  additions = final: _: import ../pkgs { pkgs = final; };

  neovim = inputs.neovim-nightly.overlays.default;

  # https://github.com/danyspin97/wpaperd/issues/79
  paperd = _final: prev: {
    wpaperd = prev.wpaperd.overrideAttrs (old: rec {
      version = "1.0.2-dev";
      src = prev.fetchFromGitHub {
        owner = "danyspin97";
        repo = "wpaperd";
        rev = "62af4392f3e447592f768f5420821a344d190107";
        hash = "sha256-6ThcLPPfdEDtAEX91WIa6zf8piPIqRvdG68+m3JWXvM=";
      };
      cargoDeps = old.cargoDeps.overrideAttrs (
        prev.lib.const {
          inherit src;
          outputHash = "sha256-+C1kclLFjQPIJmN2+YLL5/xToZjcX0wom63R2VhjPtA=";
        }
      );
    });
  };

  # https://github.com/hyprwm/Hyprland/issues/7059
  hyprutils = _final: prev: {
    hyprutils = prev.hyprutils.overrideAttrs (_old: rec {
      version = "0.2.3";
      src = prev.fetchFromGitHub {
        owner = "hyprwm";
        repo = "hyprutils";
        rev = "refs/tags/v${version}";
        hash = "sha256-9gsVvcxW9bM3HMcnHHK+vYHOzXb1ODFqN+sJ4zIRsAU=";
      };
    });
  };
  hyprland = _final: prev: {
    hyprland = prev.hyprland.overrideAttrs (_old: {
      version = "0.44.0-dev";
      src = prev.fetchFromGitHub {
        owner = "hyprwm";
        repo = "Hyprland";
        fetchSubmodules = true;
        rev = "e2426942e5716a742ea353d2a1de7d7760fbbb41";
        hash = "sha256-ZRYHQ/ZduCPxthuCFDYSDjKoSReYZy95rSm6ut8l/qE=";
      };
      patches = [
        ./stdcxx.patch
        ./cmake-version.patch
      ];
    });
  };

  # https://github.com/librespot-org/librespot/pull/1309
  # to use the oauth feature
  librespot = _final: prev: {
    librespot = prev.librespot.overrideAttrs (old: rec {
      pname = "librespot";
      version = "0.4.3-dev";
      src = prev.fetchFromGitHub {
        owner = "librespot-org";
        repo = pname;
        rev = "3781a089a69ce9883a299dfd191d90c9a5348819";
        hash = "sha256-1ABtD/bYc0PHEYQLKG5HQgM+g5h680PFddLgafoh7Kc=";
      };

      cargoDeps = old.cargoDeps.overrideAttrs (
        prev.lib.const {
          inherit src;
          outputHash = "sha256-hFARKItpBZb07Dqw0V4Xf9TpBUJ9duT6on7qwZR34b0=";
        }
      );
    });
  };

  spotify-player = final: prev: {
    spotify-player = prev.spotify-player.overrideAttrs (old: rec {
      pname = "spotify-player";
      version = "0.19.2-dev";

      src = prev.fetchFromGitHub {
        owner = "aome510";
        repo = pname;
        rev = "b202385153a80b3e9410f4fcb91b541e41f4136e";
        hash = "sha256-O17czRq0YAvAB/c/3cKjIntHRYHLB9a8v6Cl/dC4HTc=";
      };

      patches = old.patches or [ ] ++ [
        (final.fetchpatch {
          url = "https://github.com/aome510/spotify-player/pull/552.patch";
          hash = "sha256-hzdB7GOgE6ncbm5AnkNpBNCZ6QlJ6zlUxSYB/Jc03do=";
        })
      ];

      cargoDeps = old.cargoDeps.overrideAttrs (
        prev.lib.const {
          inherit src patches;
          outputHash = "sha256-xM1RXLe1uu4ZpldJ1tCb5JowpjKqpvHvUWVWts7PSZg=";
        }
      );
    });
  };

  wl-clipboard = final: prev: {
    wl-clipboard = prev.wl-clipboard.overrideAttrs (old: {
      patches = old.patches or [ ] ++ [
        # see https://github.com/bugaevc/wl-clipboard/issues/177
        ./wl-copy.patch
        (final.fetchpatch {
          url = "https://github.com/bugaevc/wl-clipboard/pull/204.patch";
          hash = "sha256-6rljcv5yXzQeCUO6IoP1irM0qUEVgmQ+UA6vcJOYeFs=";
        })
      ];
    });
  };

  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  #
  # Thanks Misterio77!
  flake-inputs = final: _: {
    inputs = builtins.mapAttrs
      (
        _: flake:
          let
            legacyPackages = (flake.legacyPackages or { }).${final.system} or { };
            packages = (flake.packages or { }).${final.system} or { };
          in
          if legacyPackages != { } then legacyPackages else packages
      )
      inputs;
  };
}
