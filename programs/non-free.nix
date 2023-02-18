{ lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "dropbox"
    "skypeforlinux"
    "slack"
    "zoom"
  ];
}

