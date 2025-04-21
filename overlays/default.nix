{inputs, ...}: {
  additions = final: _: import ../pkgs {pkgs = final;};

  neovim = inputs.neovim-nightly.overlays.default;

  zig = inputs.zig.overlays.default;

  # paperd = import ./wpaperd;

  cliphist = import ./cliphist;

  rust = inputs.rust-overlay.overlays.default;

  nur = inputs.nur.overlays.default;

  wl-clipboard = import ./wl-clipboard;

  # https://github.com/NixOS/nixpkgs/issues/399907
  qt6gtk2 = final: prev: {
    qt6Packages = prev.qt6Packages.overrideScope (_: kprev: {
      qt6gtk2 = kprev.qt6gtk2.overrideAttrs (_: {
        version = "0.5-unstable-2025-03-04";
        src = final.fetchFromGitLab {
          domain = "opencode.net";
          owner = "trialuser";
          repo = "qt6gtk2";
          rev = "d7c14bec2c7a3d2a37cde60ec059fc0ed4efee67";
          hash = "sha256-6xD0lBiGWC3PXFyM2JW16/sDwicw4kWSCnjnNwUT4PI=";
        };
      });
    });
  };

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
