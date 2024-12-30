# treefmt.nix
{
  lib,
  pkgs,
  ...
}: {
  projectRootFile = "flake.nix";
  programs = {
    shfmt.enable = true;
    stylua.enable = true;
    yamlfmt.enable = true;
    mdformat.enable = true;
    toml-sort.enable = true;
    jsonfmt.enable = true;
    ruff-check.enable = true;
    ruff-format.enable = true;
  };

  settings = {
    on-unmatched = "info";
    excludes = [
      "*.conf"
      "*.css"
      "*.pub"
      "flake.lock"
      "*.ini"
    ];
  };
  settings.formatter.shfmt = {
    includes = [
      "*.sh"
      "*.zsh"
      "scripts/*"
    ];
  };

  settings.formatter.nix = {
    command = "sh";
    options = [
      "-eucx"
      ''
        # First deadnix
        ${lib.getExe pkgs.deadnix} --edit "$@"
        # Then nixpkgs-fmt
        ${lib.getExe pkgs.alejandra} "$@"
      ''
      "--"
    ];
    includes = ["*.nix"];
  };
}
