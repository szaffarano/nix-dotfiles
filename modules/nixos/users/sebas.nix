{ hostName
, userName ? "sebas"
, email ? "sebas@zaffarano.com.ar"
,
}:
{ config
, lib
, localLib
, flakeRoot
, pkgs
, ...
}:
let
  keys = pkgs.fetchurl {
    url = "https://github.com/szaffarano.keys";
    hash = "sha256-swpi92w8GVs+9csXZBfNCLQ2GGYyKEk9ErrrbsOJY1E=";
  };

  gpgKeys = builtins.readFile (
    pkgs.fetchurl {
      url = "https://api.github.com/users/szaffarano/gpg_keys";
      hash = "sha256-6drqcf2yREpDGNySzAxIouqdGv3P8HBP7T7NKhb+oM4=";
    }
  );

  userGpgKeys = builtins.map (k: k.key_id) (
    builtins.filter (e: !e.revoked && (builtins.elemAt e.emails 0).email == email) (
      builtins.fromJSON gpgKeys
    )
  );

  hasGpgKeys = (builtins.length userGpgKeys) > 0;
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
        "${flakeRoot}/modules/home-manager"
        "${flakeRoot}/users/${userName}/${hostName}.nix"
      ];
      config = {
        home.custom.features.enable = [ "gh" ];
        programs = {
          gpg = {
            enable = true;
            settings = {
              trusted-key = lib.mkIf hasGpgKeys (builtins.elemAt userGpgKeys 0);
              default-key = lib.mkIf hasGpgKeys (builtins.elemAt userGpgKeys 0);
            };
          };

          git = {
            enable = true;
            userEmail = email;
            userName = "Sebastián Zaffarano";
            signing.key = lib.mkIf hasGpgKeys (builtins.elemAt userGpgKeys 0);
          };
        };
      };
    };
  };
}
