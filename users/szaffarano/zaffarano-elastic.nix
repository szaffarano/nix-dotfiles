{pkgs, ...}: {
  home = {
    custom = {
      features.enable = [];
      allowed-unfree-packages = [];
      permitted-insecure-packages = ["python-2.7.18.8"]; # needed by bazel-5.1.1
    };
    packages = with pkgs; [
      asciinema
      asciinema-agg
      bazel_5_1_1
      devpod
      inputs.org-mcp-server.default
      mullvad-browser
      openssl
      pkg-config
      upx
      wl-clipboard
    ];
  };

  desktop = {
    enable = true;
    wayland.compositors.hyprland.enable = false;
    wayland.compositors.sway.enable = true;
  };
  services = {
    flameshot = {
      enable = false;
      package = pkgs.flameshot-grim;
    };
    syncthing.enable = true;
  };
  terminal.cli = {
    cloud.enable = true;
    jujutsu.enable = true;
  };
  programs.nix-index.enable = true;
  develop = {
    enable = true;
    asm.enable = true;
    emacs.enable = true;
    idea = {
      enable = true;
      ultimate = true;
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

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  programs.mise.enable = true;

  sound.enable = true;
}
