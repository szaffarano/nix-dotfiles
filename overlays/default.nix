{inputs, ...}: {
  additions = final: _: import ../pkgs {pkgs = final;};

  neovim = inputs.neovim-nightly.overlays.default;

  zig = inputs.zig.overlays.default;

  cliphist = import ./cliphist;

  nur = inputs.nur.overlays.default;

  wl-clipboard = import ./wl-clipboard;

  spotify-player = import ./spotify-player;

  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  #
  # Thanks Misterio77!
  flake-inputs = final: _: {
    inputs =
      builtins.mapAttrs (
        _: flake: let
          legacyPackages = (flake.legacyPackages or {}).${final.system} or {};
          packages = (flake.packages or {}).${final.system} or {};
        in
          if legacyPackages != {}
          then legacyPackages
          else packages
      )
      inputs;
  };
}
