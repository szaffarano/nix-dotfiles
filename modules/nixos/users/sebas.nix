{ hostName
, userName ? "sebas"
,
}:
{ config
, lib
, localLib
, flakeRoot
, inputs
, pkgs
, ...
}:
let
  keys = pkgs.fetchurl {
    url = "https://github.com/szaffarano.keys";
    hash = "sha256-swpi92w8GVs+9csXZBfNCLQ2GGYyKEk9ErrrbsOJY1E=";
  };
in
{
  users = {
    users.${userName} = {
      hashedPasswordFile = config.sops.secrets."${userName}-password".path;
      extraGroups =
        [
          "wheel"
          "networkmanager"
          "video"
          "audio"
        ]
        ++ (lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ])
        ++ (lib.optionals config.virtualisation.docker.enable [ "docker" ]);

      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile keys);
    };
  };

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit localLib;
    };
    users.${userName} = {
      imports = [
        inputs.nix-colors.homeManagerModule
        inputs.nix-index-database.hmModules.nix-index
        inputs.nur.nixosModules.nur

        "${flakeRoot}/modules/home-manager"
        "${flakeRoot}/users/${userName}/${hostName}.nix"
      ];
      config = {
        git = {
          user = {
            name = "Sebastián Zaffarano";
          };
        };
      };
    };
  };
}
