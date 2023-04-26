{ self, ... }:
{ config, lib, pkgs, ... }: {
  imports = [ ../common.nix ../common-linux.nix ../security.nix ];

  git = {
    enable = true;
    user = {
      name = "Sebastián Zaffarano";
      email = "sebastian.zaffarano@elastic.co";
      signingKey = "0xB31A0D3EFDC15D4B";
    };
  };

  gpg = {
    enable = true;
    default-key = "0xB31A0D3EFDC15D4B";
    trusted-key = "0xB31A0D3EFDC15D4B";
  };
}
