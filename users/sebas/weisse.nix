_: {
  desktop = {
    enable = true;
    wayland.enable = false;
    xorg = {
      enable = true;
      compositors.i3.enable = true;
    };
    terminal = {
      foot.enable = false;
      alacritty.enable = true;
    };
  };

  services.syncthing.enable = true;
  programs.nix-index.enable = true;
  develop = {
    enable = true;
    asm.enable = true;
    idea.enable = false;
    ocaml.enable = false;
    zig.enable = false;
  };

  terminal = {
    cli.cloud.enable = false;
    fish.enable = true;
    zsh = {
      enable = false;
      extras = [
        "local"
        "binds"
        "breeze"
      ];
    };
  };

  programs.mise.enable = true;
  sound.enable = false;
}
