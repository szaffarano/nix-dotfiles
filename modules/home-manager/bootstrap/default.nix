{ lib
, config
, inputs
, outputs
, ...
}:
let
  inherit (inputs.nix-colors) colorSchemes;
in
{
  config = {
    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;

      config.allowUnfreePredicate =
        let
          packageNames = map lib.getName config.home.custom.allowed-unfree-packages;
        in
        lib.mkDefault (
          pkg:
          let
            packageName = lib.getName pkg;
            exists = builtins.elem packageName packageNames;
          in
          if exists && config.home.custom.debug then
            builtins.trace "Allowing the non-free package '${packageName}' to be installed" exists
          else
            exists
        );
    };

    programs = {
      git.enable = true;
    };

    home = {
      username = lib.mkDefault outputs.user.name;
      homeDirectory = lib.mkDefault "/home/${config.home.username}";
      stateVersion = lib.mkDefault "23.05";
      sessionPath = [ "$HOME/.local/bin" ];
      sessionVariables = {
        FLAKE = "$HOME/.dotfiles";
      };
    };

    colorscheme = lib.mkDefault colorSchemes.dracula;

    home.file.".colorscheme".text = config.colorscheme.slug;
  };
}
