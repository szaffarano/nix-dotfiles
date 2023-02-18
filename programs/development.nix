{ config, lib, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      jetbrains.idea-community
      nodejs
      go
      nixfmt
      rustc
      clippy
      cargo
      rustfmt
      rust-analyzer
    ];
  };
}
