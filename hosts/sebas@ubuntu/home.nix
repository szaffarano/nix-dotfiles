{ config, pkgs, nixpkgs, lib, ... }:
{
  imports = [ ../common.nix ../common-linux.nix ../../programs/non-free.nix ];
}
