{pkgs, ...}: {
  home = {
    custom = {
      features.enable = [];
      permitted-insecure-packages = ["python-2.7.18.8"]; # needed by bazel-5.1.1
    };
    packages = [
      pkgs.bazel_5_1_1
    ];
  };

  desktop = {
    enable = true;
    wayland.compositors.hyprland.enable = true;
    wayland.compositors.sway.enable = false;
  };
  services.flameshot = {
    enable = false;
    package = pkgs.flameshot-grim;
  };
  terminal.cli.cloud.enable = true;
  services.syncthing.enable = true;
  programs.nix-index.enable = true;
  develop = {
    enable = true;
    asm.enable = true;
    idea = {
      enable = true;
      ultimate = true;
    };
    ocaml.enable = true;
    python.enable = true;
    rust.enable = true;
    zig.enable = true;
  };

  terminal.zsh = {
    enable = true;
    extras = [
      "local"
      "binds"
      "breeze"
      "ocaml"
    ];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  programs.mise.enable = true;

  sound.enable = true;
}
