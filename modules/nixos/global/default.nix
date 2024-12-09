{ ... }:
{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./misc.nix
    ./hardware.nix
    ./locale.nix
    ./openssh.nix
    ./sops.nix
    ./system
  ];
}
