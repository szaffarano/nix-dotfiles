{ lib
, inputs
, pkgs
, ...
}:
{
  config = {
    nix = {
      package = lib.mkDefault pkgs.nix;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "repl-flake"
        ];
        trusted-users = [
          "root"
          "@wheel"
        ];
        auto-optimise-store = lib.mkDefault true;
        warn-dirty = lib.mkDefault false;
        flake-registry = lib.mkDefault ""; # Disable global flake registry
      };
      gc = lib.mkDefault {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 3d";
      };

      # To make nix3 commands consistent with the flake
      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

      # Add nixpkgs input to NIX_PATH
      # This lets nix2 commands still use <nixpkgs>
      nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
    };
  };
}
