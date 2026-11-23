{pkgs, ...}: {
  home = {
    custom = {
      features.enable = [];
      allowed-unfree-packages = [pkgs.confluent-cli];
    };
    packages = [];
  };

  desktop = {
    enable = true;
    xorg = {
      enable = true;
      compositors.i3.enable = true;
    };
    terminal = {
      foot.enable = false;
      alacritty.enable = true;
    };
    wayland.cliphist.enable = false;
    tools = {
      gammastep.enable = false;
    };
  };
  services = {
    syncthing.enable = true;
  };
  terminal.cli = {
    zellij.enable = false;
    cloud.enable = true;
    jujutsu.enable = false;
  };
  develop = {
    enable = true;
    asm.enable = false;
    emacs.enable = false;
    idea = {
      enable = false;
      ultimate = false;
    };
    ocaml.enable = false;
    python.enable = true;
    nodejs.enable = true;
    rust.enable = true;
    zig.enable = true;
  };

  terminal = {
    zsh.enable = false;
    fish.enable = true;
  };

  programs = {
    mise.enable = true;
    nix-index.enable = true;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  sound.enable = true;
}
