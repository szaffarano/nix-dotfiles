{ lib, inputs, pkgs, config, ... }:
let cfg = config.nixos.system;
in with lib; {
  options.nixos.system = {
    user = mkOption {
      type = types.str;
      default = "sebas";
    };
    authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of public keys";
    };
    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [ "wheel" "networkmanager" "video" "audio" ]
        ++ (lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ])
        ++ (lib.optionals config.virtualisation.docker.enable [ "docker" ]);
      description = "Groups to include the user";
    };
  };

  config = {
    # If set to true, you are free to add new users and groups to the system with the ordinary useradd and groupadd commands
    users.mutableUsers = false;
    users.users."${cfg.user}" = {
      isNormalUser = true;
      extraGroups = cfg.extraGroups;
      shell = pkgs.zsh;
      initialPassword = "changeme!"; # TODO: improve it!!!!!!
      openssh.authorizedKeys.keys = cfg.authorizedKeys;
      packages = [ pkgs.home-manager ];
    };

    nix = {
      package = lib.mkDefault pkgs.nix;
      settings = {
        experimental-features = [ "nix-command" "flakes" "repl-flake" ];
        trusted-users = [ "root" "@wheel" ];
        auto-optimise-store = lib.mkDefault true;
        warn-dirty = false;
        flake-registry = ""; # Disable global flake registry
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than +3";
      };

      # To make nix3 commands consistent with the flake
      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

      # Add nixpkgs input to NIX_PATH
      # This lets nix2 commands still use <nixpkgs>
      nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
    };
  };
}
