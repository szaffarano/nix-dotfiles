{
  lib,
  config,
  inputs,
  outputs,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.nix-index-database.homeModules.nix-index
  ];

  config = {
    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;

      config.permittedInsecurePackages = config.home.custom.permitted-insecure-packages;

      config.allowUnfreePredicate = let
        packageNames = map lib.getName config.home.custom.allowed-unfree-packages;
      in
        lib.mkDefault (
          pkg: let
            packageName = lib.getName pkg;
            exists = builtins.elem packageName packageNames;
          in
            if exists && config.home.custom.debug
            then builtins.trace "Allowing the non-free package '${packageName}' to be installed" exists
            else exists
        );
    };

    programs = {
      git.enable = true;
    };

    home = {
      homeDirectory = lib.mkDefault "/home/${config.home.username}";
      stateVersion = lib.mkDefault "23.05";
      sessionPath = ["$HOME/.local/bin"];
      sessionVariables = {
        NH_FLAKE = "$HOME/.dotfiles";
      };
    };

    colorScheme = inputs.nix-colors.colorSchemes.kanagawa;

    home.file.".colorscheme".text = config.colorScheme.slug;
  };
}
