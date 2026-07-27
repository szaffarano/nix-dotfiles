{pkgs, ...}: {
  home = {
    custom.features.enable = [];
    packages = [];

    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath [pkgs.systemd]}";
    };
  };

  desktop = {
    enable = true;
    wayland = {
      compositors.hyprland.enable = false;
      compositors.sway.enable = true;
      kanshi.lgMode = "2560x1440@59.951Hz";
      kanshi.lgScale = 1.0;
    };
  };
  terminal.cli.cloud.enable = true;
  services.syncthing.enable = true;
  programs.nix-index.enable = true;
  develop = {
    enable = true;
    idea = {
      enable = false;
      ultimate = false;
    };
    ocaml.enable = false;
    asm.enable = true;
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
