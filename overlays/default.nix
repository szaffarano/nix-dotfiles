{inputs, ...}: {
  additions = final: _:
    import ../pkgs {
      pkgs = final;
      inherit inputs;
    };

  # FIXME: not using nightly until https://github.com/nvim-orgmode/orgmode/issues/1049 is fixed
  # neovim = inputs.neovim-nightly.overlays.default;

  zig = inputs.zig.overlays.default;

  cliphist = import ./cliphist;

  # intel-graphics-compiler = import ./intel-graphics-compiler;

  nur = inputs.nur.overlays.default;

  wl-clipboard = import ./wl-clipboard;

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
