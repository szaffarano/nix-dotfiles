{ config, pkgs, nixpkgs, lib, ... }: {

  home = {
    packages = with pkgs; [
      wireshark
    ];
  };
}
