{ username ? "sebas"
,
}:
{ config
, lib
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
    users.${username} = {
      hashedPasswordFile = config.sops.secrets."${username}-password".path;
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
}
