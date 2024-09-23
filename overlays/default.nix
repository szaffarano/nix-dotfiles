{ inputs, ... }:
{

  additions = final: _: import ../pkgs { pkgs = final; };

  neovim = inputs.neovim-nightly.overlays.default;

  spotify-player = final: prev: {
    spotify-player = prev.spotify-player.overrideAttrs (old: rec {
      pname = "spotify-player";
      version = "0.19.2-dev";

      src = prev.fetchFromGitHub {
        owner = "aome510";
        repo = pname;
        rev = "9c47701cd6adc45c2d61721ccbdfae54ba67a523";
        hash = "sha256-FLOM8RKm8lWSqZSZm4nJwIJm/zbDQ8A7FoR7AJ+tkpc=";
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
