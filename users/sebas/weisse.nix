_: {
  desktop = {
    enable = true;
    wayland = {
      compositors.hyprland.enable = false;
      compositors.sway.enable = true;
      kanshi.lgMode = "2560x1440@59.951Hz";
      kanshi.lgScale = 1.0;
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
