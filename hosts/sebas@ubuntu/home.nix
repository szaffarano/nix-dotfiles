{ self, ... } : { config, lib, pkgs, ... }:
{
  imports = [ ../common.nix ../common-linux.nix ../../programs/non-free.nix ];
}
