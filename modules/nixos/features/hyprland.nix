{ config
, inputs
, pkgs
, ...
}:
let
  feature_name = "hyprland";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  config = {
    programs = {
      hyprland = {
        enable = enabled;
        xwayland.enable = true;
        portalPackage =
          inputs.nixpkgs-xdph.legacyPackages.${pkgs.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };
    };

    nixos.custom.features.register = feature_name;
  };
}
