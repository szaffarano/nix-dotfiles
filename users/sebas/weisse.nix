_: {
  desktop = {
    enable = true;
    wayland.compositors.hyprland.enable = true;
    wayland.compositors.sway.enable = false;
  };

  terminal.cli.cloud.enable = false;
  services.syncthing.enable = true;
  programs.nix-index.enable = true;
  develop = {
    enable = true;
    asm.enable = true;
    idea.enable = false;
    ocaml.enable = false;
    zig.enable = true;
  };

  terminal.zsh = {
    enable = true;
    extras = [
      "local"
      "binds"
      "breeze"
    ];
  };

  programs.mise.enable = true;
  sound.enable = false;
}
