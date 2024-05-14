{ lib, config, ... }:
with lib;
{
  imports = [ ./nix.nix ];

  options.nixos.system = {
    user = mkOption { type = types.str; };
    hashedPasswordFile = mkOption { type = types.str; };
    authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of public keys";
    };
    extraGroups = mkOption {
      type = types.listOf types.str;
      default =
        [
          "wheel"
          "networkmanager"
          "video"
          "audio"
        ]
        ++ (lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ])
        ++ (lib.optionals config.virtualisation.docker.enable [ "docker" ]);
      description = "Groups to include the user";
    };
  };
}
