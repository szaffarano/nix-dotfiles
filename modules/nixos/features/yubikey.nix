{ config
, inputs
, lib
, pkgs
, ...
}:
let
  feature_name = "yubikey";

  enabled = builtins.elem feature_name config.nixos.custom.features.enable;
in
{
  config = {
    services = lib.mkIf enabled {
      pcscd = {
        enable = true;
        plugins = [
          inputs.nixpkgs-ccid.legacyPackages.${pkgs.hostPlatform.system}.ccid
        ];
      };
      udev.packages = with pkgs; [
        yubikey-personalization
      ];
    };

    environment.systemPackages =
      with pkgs;
      lib.mkIf enabled [
        pcsc-tools
        yubikey-personalization
        yubikey-personalization-gui
      ];

    nixos.custom.features.register = feature_name;
  };
}
