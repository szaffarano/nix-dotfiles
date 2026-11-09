{
  pkgs,
  lib,
  ...
}: {
  home = {
    custom = {
      features.enable = [];
      allowed-unfree-packages = [pkgs.confluent-cli];
    };
    packages = [];
  };

  desktop = {
    enable = false;
    wayland = {
      compositors.hyprland.enable = false;
      compositors.sway.enable = false;
    };
  };
  services = {
    syncthing.enable = false;
  };
  terminal.cli = {
    zellij.enable = false;
    cloud.enable = false;
    jujutsu.enable = false;
  };
  develop = {
    enable = false;
    asm.enable = false;
    emacs.enable = false;
    idea = {
      enable = false;
      ultimate = false;
    };
    ocaml.enable = false;
    python.enable = false;
    nodejs.enable = false;
    rust.enable = false;
    zig.enable = false;
  };

  terminal = {
    zsh.enable = false;
    fish.enable = true;
  };

  programs = {
    mise.enable = false;
    nix-index.enable = true;
  };

  sound.enable = true;
}
