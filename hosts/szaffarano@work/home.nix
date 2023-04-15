{ self, ... }:
{ config, lib, pkgs, ... }: {
  imports = [ ../common.nix ../common-linux.nix ];

  git = {
    enable = true;
    user = {
      name = "Sebastián Zaffarano";
      email = "sebas@zaffarano.com.ar";
      signingKey = "0x14F35C58A2191587";
    };
  };

  gpg = {
    enable = true;
    default-key = "0x14F35C58A2191587";
    trusted-key = "0x14F35C58A2191587";
  };
}
