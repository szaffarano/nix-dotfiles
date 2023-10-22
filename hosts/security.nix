{ config, pkgs, nixpkgs, lib, ... }: {

  home = {
    packages = with pkgs; [
      wireshark
      psmisc
      tor-browser-bundle-bin
      age
      ssh-to-age
      age-plugin-yubikey
      sops
    ];
  };
}
