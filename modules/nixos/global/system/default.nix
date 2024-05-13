{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
let
  cfg = config.nixos.system;
in
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

  config = {
    users.mutableUsers = lib.mkDefault false;
    users.users."${cfg.user}" = {
      inherit (cfg) hashedPasswordFile extraGroups;
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = cfg.authorizedKeys;
    };
  };
}
