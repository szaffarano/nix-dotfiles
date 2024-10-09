{ inputs, ... }:
{

  additions = final: _: import ../pkgs { pkgs = final; };

  neovim = inputs.neovim-nightly.overlays.default;

  zig = inputs.zig.overlays.default;

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
  hyprland = _final: prev: {
    hyprland = prev.hyprland.overrideAttrs (_old: {
      version = "0.44.1";
      src = prev.fetchFromGitHub {
        owner = "hyprwm";
        repo = "Hyprland";
        fetchSubmodules = true;
        rev = "v0.44.1";
        hash = "sha256-hnoPoxMFetuoXQuAMgvopl1kCRQ33FYaVVBgV9FIFkM=";
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
