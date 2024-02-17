{ lib, config, inputs, outputs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
in
{
  config = {
    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;
      config = { allowUnfreePredicate = outputs.lib.unfreePredicate; };
    };

    programs = {
      home-manager.enable = true;
      git.enable = true;
    };

    home = {
      username = lib.mkDefault outputs.user.name;
      homeDirectory = lib.mkDefault "/home/${config.home.username}";
      stateVersion = lib.mkDefault "23.05";
      sessionPath = [ "$HOME/.local/bin" ];
      sessionVariables = { FLAKE = "$HOME/.dotfiles"; };
    };

    colorscheme = lib.mkDefault colorSchemes.dracula;

    home.file.".colorscheme".text = config.colorscheme.slug;
  };
}
